class User < ApplicationRecord
  before_save :downcase_email
  before_validation :downcase_email
  validates :name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password

  private
    def downcase_email
      self.email.downcase! if self.email
    end
end
