class CreateVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :color, null: false
      t.string :size, null: false
      t.integer :quantity, default: 0, null: false

      t.timestamps
    end
  end
end
