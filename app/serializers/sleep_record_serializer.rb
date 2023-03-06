class SleepRecordSerializer
  include FastJsonapi::ObjectSerializer
  attributes :humanize_total_sleep_length
  belongs_to :user
end