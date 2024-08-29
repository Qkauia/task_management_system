# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true

  scope :unread, -> { where(read_at: nil) }
  scope :old, ->(days = 7) { where(created_at: ...(Time.current - days.days)) }
end
