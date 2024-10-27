module Clients
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_cart_items, only: [:new, :create]

    def new
      @order = Order.new
      @subtotal = @cart_items.sum { |item| item.product.price * item.quantity }
      @shipping = 10.00  # Fixed shipping cost
      @total = @subtotal + @shipping
    end

    def create
      # Retrieve payment details and other form details from the form submission
      payment_details = params[:payment_details]
      card_number = payment_details[:card_number]
      expiry = payment_details[:expiry]
      cvv = payment_details[:cvv]

      billing_details = {
        first_name: params[:order][:first_name],
        last_name: params[:order][:last_name],
        address: params[:order][:address],
        city: params[:order][:city],
        zip: params[:order][:zip],
        phone: params[:order][:phone],
        email: params[:order][:email]
      }

      shipping_details = if params[:order][:different_address] == "1"
                           {
                             first_name: params[:order][:shipping_first_name],
                             last_name: params[:order][:shipping_last_name],
                             address: params[:order][:shipping_address],
                             city: params[:order][:shipping_city],
                             zip: params[:order][:shipping_zip]
                           }
                         else
                           billing_details
                         end

      # Simulate payment processing (replace with real payment gateway in production)
      if valid_payment?(card_number, expiry, cvv)
        @order = current_user.orders.new(
          subtotal: @cart_items.sum { |item| item.product.price * item.quantity },
          shipping_cost: 10.00,
          total_price: @cart_items.sum { |item| item.product.price * item.quantity } + 10.00,
          billing_details: billing_details,
          shipping_details: shipping_details
        )

        if @order.save
          # Create order items from cart items
          @cart_items.each do |cart_item|
            @order.order_items.create(
              variant_id: cart_item.variant&.id,
              product_id: cart_item.product_id,
              quantity: cart_item.quantity,
              unit_price: cart_item.product.price
            )
          end

          clear_cart
          redirect_to order_confirmation_clients_order_path(@order), notice: 'Order placed successfully! Here is your order summary.'
        else
          flash.now[:alert] = 'There was a problem placing your order. Please try again.'
          render :new
        end
      else
        flash.now[:alert] = 'Payment details are invalid. Please check your information.'
        render :new
      end
    end

    # Confirms the payment for the order
    def confirm_payment
      @order = Order.find(params[:id])
      clear_cart  # Clear cart only after payment confirmation
      redirect_to order_confirmation_clients_order_path(@order), notice: 'Payment successful! Thank you for your order.'
    end

    def order_confirmation
      @order = Order.find(params[:id])
    end

    # Generate Invoice action
    def generate_invoice
      @order = Order.find(params[:id])
      
      # Check if an invoice already exists for this order
      @invoice = Invoice.find_by(order_id: @order.id)
      
      # Create a new invoice if one does not already exist
      unless @invoice
        @invoice = Invoice.create(
          order_id: @order.id,
          invoice_number: "INV-#{@order.id}-#{Time.now.to_i}",
          subtotal: @order.subtotal,
          shipping_cost: @order.shipping_cost,
          total_price: @order.total_price
        )
      end

      # Generate PDF invoice
      pdf = generate_pdf_invoice(@order)
      
      # Send generated PDF to the user
      send_data pdf.render, filename: "invoice_order_#{@order.id}.pdf", type: 'application/pdf', disposition: 'inline'
    end

    # Show an order details page
    def show
      @order = Order.find(params[:id])
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
      params.require(:order).permit(
        :address, :city, :zip, :phone, :email, :first_name, :last_name,
        billing_details: [:first_name, :last_name, :address, :city, :zip, :phone, :email],
        shipping_details: [:first_name, :last_name, :address, :city, :zip]
      )
    end

    def clear_cart
      CartItem.where(user_id: current_user.id).destroy_all
    end

    # Mock payment validation method (replace with real payment API call in production)
    def valid_payment?(card_number, expiry, cvv)
      card_number.present? && expiry.present? && cvv.present?
    end

    # PDF generation method for invoices
    def generate_pdf_invoice(order)
      Prawn::Document.new do
        # Title
        text "Invoice", size: 30, style: :bold, align: :center
        move_down 10

        # Order Information
        text "Order ID: #{order.id}", size: 15
        text "Order Date: #{order.created_at.strftime('%d %b, %Y')}", size: 15
        move_down 20

        # Billing Details
        text "Billing Information:", size: 18, style: :bold
        text "Name: #{order.billing_details['first_name']} #{order.billing_details['last_name']}"
        text "Address: #{order.billing_details['address']}, #{order.billing_details['city']}, #{order.billing_details['zip']}"
        text "Phone: #{order.billing_details['phone']}"
        text "Email: #{order.billing_details['email']}"
        move_down 20

        # Shipping Details (if different from billing)
        if order.billing_details != order.shipping_details
          text "Shipping Information:", size: 18, style: :bold
          text "Name: #{order.shipping_details['first_name']} #{order.shipping_details['last_name']}"
          text "Address: #{order.shipping_details['address']}, #{order.shipping_details['city']}, #{order.shipping_details['zip']}"
          move_down 20
        end

        # Products Purchased
        text "Order Summary:", size: 18, style: :bold
        table_data = [["Product Name", "Unit Price", "Quantity", "Subtotal"]]
        order.order_items.each do |item|
          table_data << [
            item.product.name,
            "$#{item.unit_price}",
            item.quantity,
            "$#{item.unit_price * item.quantity}"
          ]
        end
        table(table_data, header: true, width: bounds.width)

        move_down 20

        # Price Summary
        text "Subtotal: $#{order.subtotal}", size: 14
        text "Shipping: $#{order.shipping_cost}", size: 14
        text "Total: $#{order.total_price}", size: 14, style: :bold
      end
    end
  end
end
