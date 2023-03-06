class User < ApplicationRecord

  # Associations
  has_many :clock_times, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  # Validations
  validates :name, presence: true

  def sleep_records
    friend_ids = friends.collect{|x| x.id}

    # It will skip corrupted data such as
    # user forgot to clock_in or clock_out
    ClockTime.select('user_id, sum(sleep_length) as total_sleep_length')
             .group(:user_id)
             .order('total_sleep_length desc')
             .where(user_id: friend_ids)
             .where.not(clock_in: nil, clock_out: nil)
  end
end
