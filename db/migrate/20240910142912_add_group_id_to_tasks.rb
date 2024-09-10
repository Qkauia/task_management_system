# frozen_string_literal: true

class AddGroupIdToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :group_id, :bigint
    add_index :tasks, :group_id
  end
end
