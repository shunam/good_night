class SleepRecordSerializer
  include JSONAPI::Serializer
  attributes :humanize_total_sleep_length
  belongs_to :user
end