class UpdateDeviseToAdmins < ActiveRecord::Migration[7.1]
  def change
    change_table :admins do |t|
      unless column_exists?(:admins, :email)
        t.string :email,              null: false, default: ""
      end
      unless column_exists?(:admins, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end
      unless column_exists?(:admins, :reset_password_token)
        t.string   :reset_password_token
      end
      unless column_exists?(:admins, :reset_password_sent_at)
        t.datetime :reset_password_sent_at
      end
      unless column_exists?(:admins, :remember_created_at)
        t.datetime :remember_created_at
      end
    end

    add_index :admins, :email,                unique: true
    add_index :admins, :reset_password_token, unique: true
  end
end
