class Task < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags, dependent: :destroy

  enum priority: { low: 1, medium: 2, high: 3 }
  enum status: { pending: 1, in_progress: 2, completed: 3 }

  validates :title, presence: true
  validates :content, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  validate :start_time_cannot_be_greater_than_or_equal_to_end_time

  scope :with_associations, -> { includes(:tags).where(deleted_at: nil) }
  scope :filtered_by_status, ->(status) { where(status: status) if status.present? }
  scope :filtered_by_query, lambda { |query|
    cleaned_query = query.to_s.strip
    joins(:tags).where("title ILIKE ? OR content ILIKE ? OR tags.name ILIKE ?", "%#{cleaned_query}%", "%#{cleaned_query}%", "%#{cleaned_query}%").distinct if cleaned_query.present?
  }
  scope :sorted, -> { order(priority: :desc, start_time: :asc) }
  scope :ordered_by, ->(column, direction) { order(column => direction) }

  def human_priority
    I18n.t("enums.task.priority.#{priority}")
  end

  def human_status
    I18n.t("enums.task.status.#{status}")
  end

  private

  def start_time_cannot_be_greater_than_or_equal_to_end_time
    return unless start_time.present? && end_time.present? && start_time >= end_time

    errors.add(:start_time, I18n.t('tasks.errors.start_time_greater_than_end_time'))
  end
end
