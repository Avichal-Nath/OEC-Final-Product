class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product  # Assuming you're associating order items with products
end
