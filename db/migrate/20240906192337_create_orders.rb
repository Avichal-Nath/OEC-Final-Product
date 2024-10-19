class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.string :status, default: 'pending', null: false

      t.timestamps
    end
  end
end
