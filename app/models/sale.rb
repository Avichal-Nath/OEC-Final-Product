class Sale < ApplicationRecord
  belongs_to :variant

  # Validations
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
