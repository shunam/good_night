require 'rails_helper'

RSpec.describe "Users::ClockIns", type: :request do
  context 'with user Hendrik' do
    before(:each) do
      @strftime = '%Y-%m-%d %H:%M:%S'
      @user = User.create(name: 'Hendrik')
      @time = Time.now
    end

    describe "GET /index" do
      before(:each) do
        clock_times = []
        (1..30).to_a.reverse.each do |x|
          clock_times << {
            clock_in: (@time - x.seconds),
            clock_out: (@time - (x-1).seconds),
            sleep_length: 1,
            user_id: @user.id
          }
        end
        ClockTime.upsert_all(clock_times)
      end

      it "returns http success" do
        get "/v1/users/#{@user.id}/clock_ins"
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(10)

        last_data = data[9]
        expect(last_data['id']).to eq('10')

        time = @time.utc
        attributes = last_data['attributes']
        expect(attributes['clock_in'].to_time.strftime(@strftime)).to eq((time - 21.seconds).strftime(@strftime))
        expect(attributes['clock_out'].to_time.strftime(@strftime)).to eq((time - 20.seconds).strftime(@strftime))
        expect(attributes['sleep_length']).to eq(1)

        links = JSON.parse(response.body)['links']
        expect(links['next']).to eq('http://www.example.com/v1/users/1/clock_ins?page=2')
        expect(links['prev']).to eq(nil)
      end

      it "returns http success for pages 2" do
        get "/v1/users/#{@user.id}/clock_ins?page=2"
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(10)

        last_data = data[9]
        expect(last_data['id']).to eq('20')

        time = @time.utc
        attributes = last_data['attributes']
        expect(attributes['clock_in'].to_time.strftime(@strftime)).to eq((time - 11.seconds).strftime(@strftime))
        expect(attributes['clock_out'].to_time.strftime(@strftime)).to eq((time - 10.seconds).strftime(@strftime))
        expect(attributes['sleep_length']).to eq(1)

        links = JSON.parse(response.body)['links']
        expect(links['next']).to eq('http://www.example.com/v1/users/1/clock_ins?page=3')
        expect(links['prev']).to eq('http://www.example.com/v1/users/1/clock_ins?page=1')
      end

      it "returns http success for pages 3" do
        get "/v1/users/#{@user.id}/clock_ins?page=3"
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(10)

        last_data = data[9]
        expect(last_data['id']).to eq('30')

        time = @time.utc
        attributes = last_data['attributes']
        expect(attributes['clock_in'].to_time.strftime(@strftime)).to eq((time - 1.seconds).strftime(@strftime))
        expect(attributes['clock_out'].to_time.strftime(@strftime)).to eq(time.strftime(@strftime))
        expect(attributes['sleep_length']).to eq(1)

        links = JSON.parse(response.body)['links']
        expect(links['next']).to eq(nil)
        expect(links['prev']).to eq('http://www.example.com/v1/users/1/clock_ins?page=2')
      end
    end

    describe "POST /create" do
      before(:each) do 
        @params = {
          clock_in: (@time - 20.seconds).strftime(@strftime),
        }
      end

      it "returns http success" do
        post "/v1/users/#{@user.id}/clock_ins", params: @params
        expect(response).to have_http_status(:success)

        data = JSON.parse(response.body)['data']
        expect(data['id']).to eq('1')

        attributes = data['attributes']
        expect(attributes['clock_in'].to_time.strftime(@strftime)).to eq((@time - 20.seconds).strftime(@strftime))
        
        user_id = data['relationships']['user']['data']['id']
        expect(user_id.to_i).to eq(@user.id)
      end

      it "return error when user not found" do
        post "/v1/users/0/clock_ins", params: @params
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User with 'id'=0")
      end

      it "return error when clock in is empty" do
        post "/v1/users/#{@user.id}/clock_ins"

        expect(response).to have_http_status(400)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Clock in can't be blank")
      end
    end
  end
end
