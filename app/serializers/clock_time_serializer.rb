class ClockTimeSerializer
  include FastJsonapi::ObjectSerializer
  attributes :clock_in, :clock_out, :sleep_length
  belongs_to :user
end