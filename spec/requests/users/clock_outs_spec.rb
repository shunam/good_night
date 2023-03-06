require 'rails_helper'

RSpec.describe "Users::ClockOuts", type: :request do
  context 'with user Hendrik' do
    before(:each) do
      @strftime = '%Y-%m-%d %H:%M:%S'
      @user = User.create(name: 'Hendrik')
      @time = Time.now
    end

    describe "GET /index" do
      it "returns http success" do
        clock_times = []
        (1..20).to_a.reverse.each do |x|
          clock_times << {
            clock_in: (@time - x.seconds),
            clock_out: (@time - (x-1).seconds),
            sleep_length: 1,
            user_id: @user.id
          }
        end
        ClockTime.upsert_all(clock_times)

        get "/v1/users/#{@user.id}/clock_outs"
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(10)

        last_data = data[9]
        expect(last_data['id']).to eq('10')

        time = @time.utc
        attributes = last_data['attributes']
        expect(attributes['clock_in'].to_time.strftime(@strftime)).to eq((time - 11.seconds).strftime(@strftime))
        expect(attributes['clock_out'].to_time.strftime(@strftime)).to eq((time - 10.seconds).strftime(@strftime))
        expect(attributes['sleep_length']).to eq(1)
      end
    end

    describe "PATCH /update" do
      before(:each) do 
        @params = {
          clock_out: '2023-03-07 08:50:40',
        }
        ClockTime.create(user_id: @user.id, clock_in: '2023-03-05 14:50:30')
        ClockTime.create(user_id: @user.id, clock_in: '2023-03-06 14:50:30')
      end

      it "returns http success" do
        patch "/v1/users/#{@user.id}/clock_outs", params: @params
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']
        expect(data['id']).to eq('2')

        attributes = data['attributes']
        expect(attributes['clock_out'].to_time.strftime(@strftime)).to eq(@params[:clock_out])
        expect(attributes['sleep_length']).to eq(64810)

        user_id = data['relationships']['user']['data']['id']
        expect(user_id.to_i).to eq(@user.id)
      end

      it "return error when user not found" do
        patch "/v1/users/0/clock_outs", params: @params
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User with 'id'=0")
      end

      it "return error when clock time ID and clock out is empty" do
        patch "/v1/users/#{@user.id}/clock_outs"
        expect(response).to have_http_status(400)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("ID or clock out must not be empty")
      end

      it "return error when clock out is not empty in last clock in" do
        ClockTime.create(user_id: @user.id, clock_in: '2023-03-06 20:50:30', clock_out: '2023-03-06 21:50:30')

        patch "/v1/users/#{@user.id}/clock_outs", params: @params
        expect(response).to have_http_status(400)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Clock out already exist")
      end
    end
  end

end
