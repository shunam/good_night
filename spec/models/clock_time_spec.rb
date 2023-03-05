require 'rails_helper'

RSpec.describe ClockTime, type: :model do
  context 'with user Hendrik' do
    before(:each) do
      @user = User.create(name: 'Hendrik')
    end

    it 'must return exact 8 hours sleep length' do
      time_now = Time.now
      clock_time = ClockTime.new
      clock_time.clock_in = (time_now - 8.hours)
      clock_time.clock_out = time_now
      clock_time.user_id = @user.id
      clock_time.save
      expect(clock_time.sleep_length).to equal(8*60*60) #hour * minutes * seconds
    end
  end
end
