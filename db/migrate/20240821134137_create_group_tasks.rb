class CreateGroupTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :group_tasks do |t|
      t.references :group, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
