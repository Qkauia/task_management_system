# frozen_string_literal: true

class ModifyPasswordFieldsInUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :encrypted_password, :string, default: '', null: false
    add_column :users, :password_hash, :string, null: false
    add_column :users, :password_salt, :string, null: false
  end
end
