class Friendship < ApplicationRecord

  # Associations
  belongs_to :user
  belongs_to :friend, foreign_key: :friend_id, class_name: 'User'
end
