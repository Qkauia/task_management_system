# frozen_string_literal: true

class Group < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :group_tasks, dependent: :destroy
  has_many :tasks, through: :group_tasks, dependent: :destroy

  def self.grouped_by_letter
    order(:name).group_by { |group| group.name.present? ? group.name[0].upcase : '#' }
  end
end
