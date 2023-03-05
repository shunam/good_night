class User < ApplicationRecord

  # Associations
  has_many :clock_times

  # Validations
  validates :name, presence: true
end
