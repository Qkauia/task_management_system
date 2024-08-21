class TaskUser < ApplicationRecord
  belongs_to :user
  belongs_to :task

  attribute :can_edit, :boolean, default: false
end
