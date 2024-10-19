class CreateAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :admins do |t|
      t.string :name # Add other columns as necessary
      t.timestamps
    end
  end
end
