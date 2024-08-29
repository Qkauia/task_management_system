# frozen_string_literal: true

class AddImportantToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :important, :boolean
  end
end
