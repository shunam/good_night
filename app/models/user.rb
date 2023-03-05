class User < ApplicationRecord

  # Associations
  has_many :clock_times, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  # Validations
  validates :name, presence: true
end
