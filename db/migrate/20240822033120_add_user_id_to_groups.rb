# frozen_string_literal: true

class AddUserIdToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :user_id, :integer
  end
end
