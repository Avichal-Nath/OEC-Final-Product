class Product < ApplicationRecord
  has_many :variants, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :sales, through: :variants
  has_one_attached :image
  has_many :product_colors, dependent: :destroy
  has_many :colors, through: :product_colors

  accepts_nested_attributes_for :variants, allow_destroy: true

  # Validations
  validates :name, presence: true, length: { minimum: 3 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }

  # Scopes for various sections
  scope :on_sale, -> { where(on_sale: true) }
  scope :best_selling, -> { where(best_selling: true) }
  scope :new_arrivals, -> { where(new_arrival: true) }

  # Enhanced search method with options for color, size, and price filtering
  def self.search(query: nil, color: nil, size: nil, min_price: nil, max_price: nil)
    products = Product.all

    # Handle text-based search for name, description, color, and size
    if query.present?
      if query.include?('-')
        # Interpret the query as a price range if it contains a hyphen (e.g., "10-50")
        min_price, max_price = query.split('-').map(&:to_f)
        products = products.where(price: min_price..max_price)
      elsif numeric?(query)
        # If the query is numeric, search by exact price
        products = products.where(price: query.to_f)
      else
        # Case-insensitive search across name, description, color, and size
        query_param = "%#{query.downcase}%"
        if ActiveRecord::Base.connection.adapter_name == 'SQLite'
          products = products.joins(:variants).where(
            "LOWER(products.name) LIKE :query OR LOWER(products.description) LIKE :query OR LOWER(variants.color) LIKE :query OR LOWER(variants.size) LIKE :query",
            query: query_param
          )
        else
          products = products.joins(:variants).where(
            "products.name ILIKE :query OR products.description ILIKE :query OR variants.color ILIKE :query OR variants.size ILIKE :query",
            query: query_param
          )
        end
      end
    end

    # Apply additional filters for color and size
    products = products.joins(:variants).where(variants: { color: color }) if color.present?
    products = products.joins(:variants).where(variants: { size: size }) if size.present?

    # Apply price range filters
    products = products.where('price >= ?', min_price.to_f) if min_price.present?
    products = products.where('price <= ?', max_price.to_f) if max_price.present?

    products.distinct
  end

  private

  # Helper to check if a string can be converted to a numeric value
  def self.numeric?(str)
    Float(str) != nil rescue false
  end
end
