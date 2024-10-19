# app/models/cart_item.rb
class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true

  validates :color, :size, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
