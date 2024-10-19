# app/controllers/clients/orders_controller.rb
module Clients
  class OrdersController < ApplicationController
    before_action :authenticate_user!  # Ensure users are authenticated
    before_action :set_cart_items, only: [:new, :create]

    def new
      # Initialize a new order instance
      @order = Order.new
      @subtotal = @cart_items.sum { |item| item.product.price * item.quantity }
      @shipping = 10.00  # Example fixed shipping cost
      @total = @subtotal + @shipping
    end

    def create
      @order = current_user.orders.new(order_params)
      @order.subtotal = @cart_items.sum { |item| item.product.price * item.quantity }
      @order.shipping_cost = 10.00  # Example fixed shipping cost
      @order.total = @order.subtotal + @order.shipping_cost

      if @order.save
        # Clear the cart after a successful order
        clear_cart

        redirect_to clients_order_path(@order), notice: 'Order placed successfully!'
      else
        flash.now[:alert] = 'There was a problem placing your order. Please try again.'
        render :new
      end
    end

    def show
      @order = Order.find(params[:id])
      # Ensure the user can only see their orders
      if @order.user_id != current_user.id
        redirect_to clients_cart_path, alert: 'Access denied!' 
      end
    end

    private

    def set_cart_items
      @cart_items = CartItem.where(user_id: current_user.id)
      if @cart_items.empty?
        redirect_to clients_cart_path, alert: 'Your cart is empty. Please add items before proceeding to checkout.' and return
      end
    end

    def order_params
      params.require(:order).permit(:address, :payment_method)  # Include any other necessary fields
    end

    def clear_cart
      @cart_items.each do |item|
        item.destroy  # Or you can use session to clear the cart if that's how it's managed
      end
    end
  end
end
