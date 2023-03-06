class ClockTimeSerializer
  include JSONAPI::Serializer
  attributes :clock_in, :clock_out, :sleep_length
  belongs_to :user
end