class ProductsController < ApplicationController
  
  def index
    @products = if params[:query].present?
      Product.where("name LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    else
      Product.all
    end
  end

  def show
    @product = Product.find(params[:id])
    render 'admin/products/show'
  end

  
  def create
    @product = Product.new(product_params)
    puts product_params.inspect
  
    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product was successfully created.'
    else
      render 'admin/products/index'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully deleted.'
    else
      redirect_to admin_product_path(@product), alert: 'Failed to delete the product.'
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, variants_attributes: [:id, :color, :size, :quantity, :_destroy])
  end

end
