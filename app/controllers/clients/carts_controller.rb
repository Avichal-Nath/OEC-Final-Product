module Clients
  class CartsController < ApplicationController
    # Ensure authentication for all actions except show and add_item
    before_action :authenticate_user!, except: [:index, :show, :add_item]

    before_action :set_cart, only: [:show, :confirm]

    def show
      @cart_items = CartItem.where(user_id: current_user.id)
    end

    def add_item
      product = Product.find(params[:product_id])
      variant = product.variants.find_by(color: params[:color], size: params[:size])

      # Validate that variant exists and stock is sufficient
      if variant && variant.quantity >= params[:quantity].to_i
        session[:cart] ||= {}
        cart_item_key = "#{product.id}_#{variant.color}_#{variant.size}"

        # Add item to session cart if not already present, or update quantity
        session[:cart][cart_item_key] = (session[:cart][cart_item_key] || 0) + params[:quantity].to_i

        # Check if item is already in CartItem for the user, otherwise create a new one
        cart_item = CartItem.find_or_initialize_by(
          user_id: current_user.id,
          variant_id: variant.id,
          product_id: product.id,
          color: params[:color],
          size: params[:size]
        )
        cart_item.quantity += params[:quantity].to_i

        # Handle errors when saving the cart item
        if cart_item.save
          flash[:notice] = 'Item successfully added to the cart.'
        else
          flash[:alert] = 'Failed to add item to the cart. Please try again.'
        end

        redirect_to clients_cart_path
      else
        # Stock validation failed
        flash[:alert] = 'Not enough stock available.'
        redirect_back(fallback_location: clients_product_path(product))
      end
    end

    def update_quantity
      cart_item = CartItem.find_by(id: params[:id], user_id: current_user.id)
      if cart_item
        new_quantity = params[:quantity].to_i
        variant = cart_item.product.variants.find_by(color: cart_item.color, size: cart_item.size)
        
        if new_quantity > 0 && variant && variant.quantity >= new_quantity
          cart_item.update(quantity: new_quantity)
          flash[:notice] = 'Quantity updated successfully.'
        else
          flash[:alert] = 'Not enough stock available.'
        end
      else
        flash[:alert] = 'Item not found in the cart.'
      end
    
      redirect_to clients_cart_path
    end

    def confirm
      @cart_items = CartItem.where(user_id: current_user.id)

      if @cart_items.empty?
        flash[:alert] = 'Your cart is empty. Please add items before proceeding to checkout.'
        redirect_to clients_cart_path and return
      end

      # Calculate the total price
      @subtotal = @cart_items.sum { |item| item.product.price * item.quantity }
      # Placeholder for shipping cost
      @shipping = 10.00  # Example fixed shipping cost
      @total = @subtotal + @shipping

      # Prepare data for the checkout view
      render 'clients/carts/checkout'
    end

    def remove_item
      cart_item = CartItem.find_by(user_id: current_user.id, product_id: params[:id])
      if cart_item
        cart_item.destroy
        flash[:notice] = 'Item removed from cart.'
      else
        flash[:alert] = 'Item not found in cart.'
      end
      redirect_to clients_cart_path
    end

    private

    def set_cart
      # Redirect to login if the user is not logged in
      unless user_signed_in?
        redirect_to new_user_session_path, alert: 'You need to log in to access the cart.'
        return
      end

      @cart_items = CartItem.where(user_id: current_user.id)
    end
  end
end
