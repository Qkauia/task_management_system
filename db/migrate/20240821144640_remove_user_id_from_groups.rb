# frozen_string_literal: true

class RemoveUserIdFromGroups < ActiveRecord::Migration[7.1]
  def change
    remove_column :groups, :user_id, :bigint
  end
end
