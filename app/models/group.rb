# frozen_string_literal: true

class Group < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :group_tasks, dependent: :destroy
  has_many :tasks, through: :group_tasks, dependent: :destroy
end
