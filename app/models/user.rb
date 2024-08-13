class User < ApplicationRecord
  acts_as_paranoid

  before_save :encrypt_password, if: -> { password.present? }
  before_save :set_default_role

  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, if: -> { password.present? }

  attr_accessor :password, :password_confirmation, :current_password

  enum role: { user: 'user', admin: 'admin' }

  def authenticate(password)
    password_hash == encrypt(password)
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
