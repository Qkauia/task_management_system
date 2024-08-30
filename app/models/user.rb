# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid
  mount_uploader :avatar, AvatarUploader

  before_save :encrypt_password, if: -> { password.present? }
  before_save :set_default_role

  has_many :tasks, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :task_users, dependent: :destroy
  has_many :shared_tasks, through: :task_users, source: :task
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :owned_tasks, class_name: 'Task', dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, if: -> { password.present? }

  attr_accessor :password, :password_confirmation, :current_password

  enum role: { user: 'user', admin: 'admin' }

  scope :excluding_current_user, ->(current_user) { where.not(id: current_user.id) }
  scope :filtered_by_query, lambda { |query|
    cleaned_query = query.to_s.strip
    where('email ILIKE ?', "%#{cleaned_query}%").distinct if cleaned_query.present?
  }

  def authenticate(password)
    password_hash == encrypt(password)
  end

  def accessible_tasks
    owned_tasks.or(shared_tasks)
  end

  def self.grouped_by_letter(exclude_id: nil)
    scope = exclude_id ? where.not(id: exclude_id) : all
    scope.order(:email).group_by { |user| user.email[0].upcase }
  end

  private

  def encrypt_password
    self.password_salt = SecureRandom.hex(16)
    self.password_hash = encrypt(password)
  end

  def encrypt(password)
    Digest::SHA2.hexdigest(password + password_salt)
  end

  def set_default_role
    self.role ||= :user
  end
end
