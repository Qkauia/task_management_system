class Task < ApplicationRecord
  belongs_to :user

  enum priority: { low: 1, medium: 2, high: 3 }
  enum status: { pending: 1, in_progress: 2, completed: 3 }

  validates :title, presence: true
  validates :priority, presence: true
  validates :status, presence: true
end
