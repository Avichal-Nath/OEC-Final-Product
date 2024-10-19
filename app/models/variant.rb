class Variant < ApplicationRecord
  belongs_to :product
  has_many :sales, dependent: :destroy

  # Validations
  validates :color, presence: true, uniqueness: { scope: [:size, :product_id], message: "and size combination should be unique per product." }
  validates :size, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_sold
    sales.sum(:quantity)
  end

  scope :out_of_stock, -> { where(quantity: 0) }
  scope :in_stock, -> { where('quantity > ?', 0) }
end
