module Clients
  class ProductsController < ApplicationController
    before_action :set_categories_colors_sizes, only: [:index, :men, :women]

    def index
      # Main search results based on the full query
      @products = Product.search(
        query: params[:search],
        color: params[:color],
        size: params[:size],
        min_price: params[:min_price],
        max_price: params[:max_price]
      )

      # Product recommendations based on the starting letters of the query
      if params[:search].present?
        @recommendations = Product.where("LOWER(name) LIKE ?", "#{params[:search].downcase}%").limit(5)
      else
        @recommendations = []
      end
    end

    def men
      @categories = Category.where(gender: 'male')
      @category = Category.find_by(name: 'Men')
      @products = @category.present? ? @category.products : Product.none
      apply_filters

      flash[:notice] = "No men's products available." if @products.empty?
    end

    def women
      @categories = Category.where(gender: 'female')
      @category = Category.find_by(name: 'Women')
      @products = @category.present? ? @category.products : Product.none
      apply_filters

      flash[:notice] = "No women's products available." if @products.empty?
    end

    def show
      @product = Product.find_by(id: params[:id])
      if @product.nil?
        flash[:alert] = "Product not found."
        redirect_to clients_products_path
      end
    end

    private

    def set_categories_colors_sizes
      @categories = Category.all
      @colors = Variant.pluck(:color).uniq
      @sizes = Variant.pluck(:size).uniq
    end

    def apply_filters
      @products = @products.joins(:variants).where(variants: { color: params[:color] }) if params[:color].present?
      @products = @products.joins(:variants).where(variants: { size: params[:size] }) if params[:size].present?
      @products = @products.where('price >= ?', params[:min_price].to_f) if params[:min_price].present?
      @products = @products.where('price <= ?', params[:max_price].to_f) if params[:max_price].present?
      @products = @products.distinct
    end
  end
end
