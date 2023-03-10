class ClockTime < ApplicationRecord
  
  # Associations
  belongs_to :user

  # Callbacks
  before_save :update_sleep_length

  # Validations
  validates :clock_in, presence: true, if: -> { clock_out.blank? }
  validates :clock_out, presence: true, if: -> { clock_in.blank? }

  def update_sleep_length
    if clock_in.present? and clock_out.present?
      self.sleep_length = clock_out.to_i - clock_in.to_i
    end
  end

  def self.last_clock_in(id:, user_id:, clock_out:)
    self.order(clock_in: :desc)
        .find_by('id = ? or (user_id = ? and clock_in <= ?)', id, user_id, clock_out)
  end

  def humanize_total_sleep_length
    tsl = (try(:total_sleep_length) or sleep_length)
    hours = tsl / 3600
    tsl -= hours * 3600
    minutes = tsl / 60
    seconds = tsl - minutes * 60
    "#{hours} hours #{minutes} minutes #{seconds} seconds"
  end
end
