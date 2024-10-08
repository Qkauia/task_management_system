# frozen_string_literal: true

class Task < ApplicationRecord
  acts_as_paranoid
  has_one_attached :file

  belongs_to :user
  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :tasks
  belongs_to :group, optional: true
  has_many :task_users, dependent: :destroy, inverse_of: :task
  has_many :shared_users, through: :task_users, source: :user
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags, dependent: :destroy
  has_many :group_tasks, dependent: :destroy
  has_many :groups, through: :group_tasks, dependent: :destroy

  enum priority: { low: 1, medium: 2, high: 3 }
  enum status: { pending: 1, in_progress: 2, completed: 3 }

  validates :title, presence: true
  validates :content, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  validate :start_time_cannot_be_greater_than_or_equal_to_end_time

  # Scope in Task model
  scope :filtered_by_status, ->(status) { where(status:) if status.present? }
  scope :filtered_by_query, lambda { |query|
    cleaned_query = query.to_s.strip
    if cleaned_query.present?
      joins('LEFT OUTER JOIN task_tags ON task_tags.task_id = tasks.id')
        .joins('LEFT OUTER JOIN tags ON tags.id = task_tags.tag_id')
        .where('tasks.title ILIKE ? ', "%#{cleaned_query}%")
        .distinct
    end
  }
  scope :sorted, -> { order(priority: :desc, start_time: :asc) }
  scope :ordered_by, ->(column, direction) { order(column => direction) }
  scope :filter_by_tag, ->(tag_id) { joins(:tags).where(tags: { id: tag_id }) if tag_id.present? }

  default_scope { order(position: :asc) }
  scope :important, -> { where(important: true) }

  scope :owned_and_shared_by, lambda { |user|
    Task.left_outer_joins(:task_users)
        .where('tasks.user_id = ? OR task_users.user_id = ?', user.id, user.id)
        .distinct
  }

  scope :with_shared_count, lambda {
    select('tasks.*, (SELECT COUNT(*) FROM task_users WHERE task_users.task_id = tasks.id AND task_users.user_id != tasks.user_id) AS shared_count')
  }

  scope :for_user_groups, lambda { |user|
    joins(:groups).where(groups: { id: user.group_ids })
  }

  def human_priority
    I18n.t("enums.task.priority.#{priority}")
  end

  def human_status
    I18n.t("enums.task.status.#{status}")
  end

  def shared_count
    if groups.any?
      groups.joins(:users).where.not(users: { id: user_id }).distinct.count('users.id')
    else
      shared_users.where.not(id: user_id).count
    end
  end

  private

  def start_time_cannot_be_greater_than_or_equal_to_end_time
    return unless start_time.present? && end_time.present? && start_time >= end_time

    errors.add(:start_time, I18n.t('tasks.errors.start_time_greater_than_end_time'))
  end
end
