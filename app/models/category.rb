class Category < ApplicationRecord
  has_many :products

  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }
end
