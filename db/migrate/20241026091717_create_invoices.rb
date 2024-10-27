class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices, if_not_exists: true do |t|
      t.integer :order_id
      t.string :invoice_number
      t.decimal :subtotal
      t.decimal :shipping_cost
      t.decimal :total_price
      t.timestamps
    end
  end
end
