# app/controllers/checkout_controller.rb
class CheckoutController < ApplicationController
  def new
    @message = params[:message]
  end

  def process_payment
    response = HTTParty.post(
      mock_payments_url,
      body: { payment_details: payment_params }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    if response.parsed_response["status"] == "success"
      redirect_to checkout_path(message: "Payment Successful!")
    else
      redirect_to checkout_path(message: "Payment Failed. Please try again.")
    end
  end

  private

  def payment_params
    params.require(:payment_details).permit(:card_number, :expiry, :cvv)
  end
end
