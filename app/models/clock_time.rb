class ClockTime < ApplicationRecord
  
  # Associations
  belongs_to :user

  # Callback
  before_save :update_sleep_length

  def update_sleep_length
    if clock_in.present? and clock_out.present?
      self.sleep_length = clock_out.to_i - clock_in.to_i
    end
  end
end
