class RemoveDeviseColumnsFromUsers < ActiveRecord::Migration[7.1]
  def up
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
  end

  def down
    add_column :users, :encrypted_password, :string, default: "", null: false
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_created_at, :datetime
  end
end
