class Admin::ProductsController < Admin::BaseController
  require 'nokogiri'
  before_action :set_filters, only: [:index, :new, :edit]
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
    filter_products
    @categories = Category.all
    @colors = Variant.pluck(:color).uniq
    @sizes = Variant.pluck(:size).uniq
  end

  def show
    @product = Product.find_by(id: params[:id])
    unless @product
      flash[:alert] = "Product not found."
      redirect_to admin_products_path
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product was successfully created.'
    else
      render 'admin/products/new'
    end
  end

  def edit; end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_products_path, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path, notice: 'Product was successfully deleted.'
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def filter_products
    # Ensure prices are within valid ranges
    if params[:min_price].present? && params[:min_price].to_f < 0
      flash[:alert] = "Minimum price cannot be less than 0."
      params[:min_price] = nil
    end

    if params[:max_price].present? && params[:max_price].to_f > 100
      flash[:alert] = "Maximum price cannot exceed 100."
      params[:max_price] = nil
    end

    if params[:min_price].present? && params[:max_price].present?
      if params[:min_price].to_f > params[:max_price].to_f
        flash[:alert] = "Minimum price cannot be greater than maximum price."
        params[:min_price] = nil
        params[:max_price] = nil
      end
    end

    # Apply filters independently
    @products = @products.search(params[:query]) if params[:query].present?
    @products = @products.joins(:category).where(categories: { id: params[:category] }) if params[:category].present?

    if params[:color].present?
      @products = @products.joins(:variants).where(variants: { color: params[:color] }).distinct
    end

    if params[:size].present?
      @products = @products.joins(:variants).where(variants: { size: params[:size] }).distinct
    end

    @products = @products.where('price >= ?', params[:min_price]) if params[:min_price].present?
    @products = @products.where('price <= ?', params[:max_price]) if params[:max_price].present?
  end

  def set_filters
    @categories = Category.all
    @colors = Variant.pluck(:color).uniq
    @sizes = Variant.pluck(:size).uniq
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, variants_attributes: [:id, :color, :size, :quantity, :_destroy])
  end

  def remove_image
    @product = Product.find(params[:id])
    @product.image.purge
    redirect_to edit_admin_product_path(@product), notice: 'Image was successfully removed.'
  end
end
