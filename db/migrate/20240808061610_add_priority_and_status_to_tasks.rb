class AddPriorityAndStatusToTasks < ActiveRecord::Migration[7.1]
  def up
    if column_exists?(:tasks, :priority)
      change_column_default :tasks, :priority, from: nil, to: 1
      change_column_null :tasks, :priority, false
    else
      add_column :tasks, :priority, :integer, default: 1, null: false
    end

    if column_exists?(:tasks, :status)
      change_column_default :tasks, :status, from: nil, to: 1
      change_column_null :tasks, :status, false
    else
      add_column :tasks, :status, :integer, default: 1, null: false
    end
  end

  def down
    if column_exists?(:tasks, :priority)
      change_column_default :tasks, :priority, from: 1, to: nil
      change_column_null :tasks, :priority, true
    else
      remove_column :tasks, :priority
    end

    if column_exists?(:tasks, :status)
      change_column_default :tasks, :status, from: 1, to: nil
      change_column_null :tasks, :status, true
    else
      remove_column :tasks, :status
    end
  end
end
