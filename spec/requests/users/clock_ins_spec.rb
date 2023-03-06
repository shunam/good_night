require 'rails_helper'

RSpec.describe "Users::ClockIns", type: :request do
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

        get "/users/#{@user.id}/clock_ins"
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(20)

        last_data = data[19]
        expect(last_data['id']).to eq('20')

        time = @time.utc
        attributes = last_data['attributes']
        expect(attributes['clock_in'].to_time.strftime(@strftime)).to eq((time - 1.seconds).strftime(@strftime))
        expect(attributes['clock_out'].to_time.strftime(@strftime)).to eq(time.strftime(@strftime))
        expect(attributes['sleep_length']).to eq(1)
      end
    end

    describe "POST /create" do
      before(:each) do 
        @params = {
          clock_in: (@time - 20.seconds).strftime(@strftime),
        }
      end

      it "returns http success" do
        post "/users/#{@user.id}/clock_ins", params: @params
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']
        expect(data['id']).to eq('1')

        attributes = data['attributes']
        expect(attributes['clock_in'].to_time.strftime(@strftime)).to eq((@time - 20.seconds).strftime(@strftime))
        
        user_id = data['relationships']['user']['data']['id']
        expect(user_id.to_i).to eq(@user.id)
      end

      it "return error when user not found" do
        post "/users/0/clock_ins", params: @params
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User with 'id'=0")
      end

      it "return error when clock in is empty" do
        post "/users/#{@user.id}/clock_ins"

        expect(response).to have_http_status(400)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Clock in can't be blank")
      end
    end
  end
end
