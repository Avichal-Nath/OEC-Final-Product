class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy  # Add this line to establish the association
  has_one :invoice, dependent: :destroy
  # Serializing billing and shipping details to store complex data in JSON fields
  store_accessor :billing_details, :first_name, :last_name, :address, :city, :zip, :phone, :email
  store_accessor :shipping_details, :first_name, :last_name, :address, :city, :zip
end
