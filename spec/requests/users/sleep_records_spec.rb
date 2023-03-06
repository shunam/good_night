require 'rails_helper'

RSpec.describe "Users::SleepRecords", type: :request do
  context 'with user Hendrik' do
    before(:each) do
      @user = User.create(name: 'Hendrik')
      @friend1 = User.create(name: 'Friend 1')
      @friend2 = User.create(name: 'Friend 2')
      @friend3 = User.create(name: 'Friend 3')
      @friend4 = User.create(name: 'Friend 4')
      @user.friends << @friend1
      @user.friends << @friend2
      @user.friends << @friend3
      @user.friends << @friend4

      ClockTime.create(user_id: @friend1.id, clock_in: '2023-03-01 20:00:00', clock_out: '2023-03-02 04:00:00')
      ClockTime.create(user_id: @friend1.id, clock_in: '2023-01-01 20:00:00', clock_out: '2023-01-02 04:00:00', created_at: '2023-01-02 04:00:00')
      ClockTime.create(user_id: @friend2.id, clock_in: '2023-03-01 20:00:00', clock_out: '2023-03-02 00:00:00')
      ClockTime.create(user_id: @friend3.id, clock_in: '2023-03-01 18:00:00', clock_out: '2023-03-02 04:00:00')
      ClockTime.create(user_id: @friend4.id, clock_in: '2023-03-01 16:00:00', clock_out: '2023-03-02 04:00:00')
      ClockTime.create(user_id: @friend4.id, clock_in: '2023-03-02 16:00:00', clock_out: '2023-03-03 04:00:00')
      ClockTime.create(user_id: @friend4.id, clock_in: '2023-03-03 16:00:00', clock_out: '2023-03-03 16:15:10')
    end

    describe "GET /index" do
      it "returns http success" do
        get "/v1/users/#{@user.id}/sleep_records"
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']

        data1 = data[0]
        expect(data1['attributes']['humanize_total_sleep_length']).to eq('24 hours 15 minutes 10 seconds')
        expect(data1['relationships']['user']['data']['id']).to eq('5')

        data2 = data[1]
        expect(data2['attributes']['humanize_total_sleep_length']).to eq('10 hours 0 minutes 0 seconds')
        expect(data2['relationships']['user']['data']['id']).to eq('4')

        data3 = data[2]
        expect(data3['attributes']['humanize_total_sleep_length']).to eq('8 hours 0 minutes 0 seconds')
        expect(data3['relationships']['user']['data']['id']).to eq('2')

        data4 = data[3]
        expect(data4['attributes']['humanize_total_sleep_length']).to eq('4 hours 0 minutes 0 seconds')
        expect(data4['relationships']['user']['data']['id']).to eq('3')
      end

      it "return error when user not found" do
        get "/v1/users/0/sleep_records"
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User with 'id'=0")
      end
    end
  end

end
