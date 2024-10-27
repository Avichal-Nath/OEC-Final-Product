class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :shipping_cost, precision: 10, scale: 2, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false  # if you choose to rename it

      t.timestamps
    end
  end
end
