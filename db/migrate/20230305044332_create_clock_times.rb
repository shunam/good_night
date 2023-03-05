class CreateClockTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :clock_times do |t|
      t.integer :user_id
      t.datetime :clock_in
      t.datetime :clock_out
      t.integer :sleep_length

      t.timestamps
    end
  end
end
