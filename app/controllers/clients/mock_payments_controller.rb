module Clients
  class MockPaymentsController < ApplicationController
    def create
      payment_details = params[:payment_details]
      
      if valid_payment?(payment_details)
        # Redirect to the orders page or the show page of the last order
        redirect_to clients_orders_path, notice: 'Payment processed successfully. Your order is confirmed!'
      else
        redirect_to clients_cart_path, alert: 'Payment failed. Please check your details.'
      end
    end

    private

    def valid_payment?(payment_details)
      payment_details[:card_number] == "696969" && 
      payment_details[:expiry] == "12/24" && 
      payment_details[:cvv] == "123"
    end
  end
end
