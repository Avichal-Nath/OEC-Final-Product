class Admin::BaseController < ApplicationController
  before_action :authenticate_admin_admin!
  private

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :image,
      variants_attributes: [:id, :color, :size, :quantity, :_destroy]
    )
  end
  def show
    @product = Product.find(params[:id])
  end
end
