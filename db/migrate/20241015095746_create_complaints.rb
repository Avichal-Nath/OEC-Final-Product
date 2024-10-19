class CreateComplaints < ActiveRecord::Migration[7.1]
  def change
    create_table :complaints do |t|
      t.string :email
      t.string :name
      t.string :product_name
      t.string :product_link
      t.text :complaint_text

      t.timestamps
    end
  end
end
