class AddBillingAndShippingDetailsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :billing_details, :jsonb
    add_column :orders, :shipping_details, :jsonb
  end
end
