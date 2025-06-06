class User < ApplicationRecord
  has_many :tasks
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
end
