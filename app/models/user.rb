class User < ApplicationRecord
  before_save :encrypt_password
  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, if: -> { password.present? }

  attr_accessor :password, :password_confirmation, :current_password

  def authenticate(password)
    password_hash == encrypt(password)
  end

  private

  def encrypt_password
    return if password.blank?

    self.password_salt = SecureRandom.hex(16)
    self.password_hash = encrypt(password)
  end

  def encrypt(password)
    Digest::SHA2.hexdigest(password + password_salt)
  end
end
