module Clients
  class ProductsController < ApplicationController
    def index
      @products = Product.all
      @categories = Category.all
      @colors = Variant.pluck(:color).uniq
      @sizes = Variant.pluck(:size).uniq

      # Apply filters if any parameters are present
      filter_products if params_present?
    end

    # Search action
    def search
      if params[:query].present?
        # Adjust for SQLite or PostgreSQL
        query_param = "%#{params[:query]}%"

        if ActiveRecord::Base.connection.adapter_name == 'SQLite'
          # For SQLite
          @products = Product.where("name LIKE ? OR description LIKE ?", query_param, query_param)
        else
          # For PostgreSQL (case-insensitive search)
          @products = Product.where("name ILIKE ? OR description ILIKE ?", query_param, query_param)
        end
      else
        @products = Product.all
      end

      render :index
    end

    def men
      # logic for showing men's wear products
      @products = Product.where(name: ['Shirt', 'T-Shirt']) # Adjust based on your model
    end

    def womens
      # logic for showing women's wear
      @products = Product.where(name: ['Dress'])
      @products = [] if @products.blank?
    end

    def show
      @product = Product.find(params[:id])
    end

    private

    def filter_products
      @products = @products.where("name LIKE ?", "%#{params[:query]}%") if params[:query].present?
      @products = @products.where(category_id: params[:category]) if params[:category].present?
      @products = @products.joins(:variants).where(variants: { color: params[:color] }).distinct if params[:color].present?
      @products = @products.joins(:variants).where(variants: { size: params[:size] }).distinct if params[:size].present?
      @products = @products.where('price >= ?', params[:min_price]) if params[:min_price].present?
      @products = @products.where('price <= ?', params[:max_price]) if params[:max_price].present?
    end

    def params_present?
      params[:query].present? || params[:category].present? || params[:color].present? || params[:size].present? ||
        params[:min_price].present? || params[:max_price].present?
    end
  end
end
