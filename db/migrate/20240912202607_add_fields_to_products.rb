class AddFieldsToProducts < ActiveRecord::Migration[7.1]
  def change
    # Check if columns exist before adding
    add_column :products, :on_sale, :boolean, default: false unless column_exists?(:products, :on_sale)
    add_column :products, :best_selling, :boolean, default: false unless column_exists?(:products, :best_selling)
    add_column :products, :new_arrival, :boolean, default: false unless column_exists?(:products, :new_arrival)
  end
end
