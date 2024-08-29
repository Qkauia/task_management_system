# frozen_string_literal: true

class Tag < ApplicationRecord
  validates :name, presence: true
  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags, dependent: :destroy
end
