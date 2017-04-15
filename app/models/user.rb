class User < ApplicationRecord
  before_save :email_downcase

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 50},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password

  def email_downcase
    self.email = email.downcase
  end
end
