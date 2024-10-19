class AddFieldsToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_items, :color, :string
    add_column :cart_items, :size, :string
    add_column :cart_items, :quantity, :integer
  end
end
