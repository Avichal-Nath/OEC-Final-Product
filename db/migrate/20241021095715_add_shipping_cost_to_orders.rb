class AddShippingCostToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :shipping_cost, :decimal, precision: 10, scale: 2
  end
end
