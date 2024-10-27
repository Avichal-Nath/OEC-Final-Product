class Invoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.references :order, null: false, foreign_key: true
      t.string :invoice_number, null: false
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :shipping_cost, precision: 10, scale: 2, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    # If you want to enforce uniqueness, you can add an index instead
    add_index :invoices, :invoice_number, unique: true
  end
end
