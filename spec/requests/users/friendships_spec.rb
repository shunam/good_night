require 'rails_helper'

RSpec.describe "Users::Friendships", type: :request do
  context 'with user Hendrik and Friend' do
    before(:each) do
      @user = User.create(name: 'Hendrik')
      @friend = User.create(name: 'Friend')
      @params = {
        friend_id: @friend.id
      }
    end

    describe "GET /follow" do
      it "returns http success" do
        post "/v1/users/#{@user.id}/friendships/follow", params: @params
        expect(response).to have_http_status(:success)
        
        data = JSON.parse(response.body)['data']
        expect(data['id']).to eq('1')

        attributes = data['attributes']
        expect(attributes['name']).to eq('Hendrik')

        relationships = data['relationships']['friends']['data'][0]
        expect(relationships['id']).to eq('2')
        expect(relationships['type']).to eq('user')
      end

      it "returns error when friend_id is empty" do
        post "/v1/users/#{@user.id}/friendships/follow"
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User without an ID")
      end

      it "return error when user not found" do
        post "/v1/users/0/friendships/follow"
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User with 'id'=0")
      end

      it "return error when friend not found" do
        post "/v1/users/#{@user.id}/friendships/follow", params: {friend_id: 0}
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User with 'id'=0")
      end
    end

    describe "GET /unfollow" do
      it "returns http success" do
        @user.friends << @friend

        delete "/v1/users/#{@user.id}/friendships/unfollow", params: @params
        expect(response).to have_http_status(:success)
        
        data = JSON.parse(response.body)['data']
        expect(data['id']).to eq('1')

        attributes = data['attributes']
        expect(attributes['name']).to eq('Hendrik')

        relationships = data['relationships']['friends']['data']
        expect(relationships.size).to eq(0)
      end

      it "returns error if empty params" do
        delete "/v1/users/#{@user.id}/friendships/unfollow"
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User without an ID")
      end

      it "return error when user not found" do
        delete "/v1/users/0/friendships/unfollow"
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User with 'id'=0")
      end

      it "return error when friend not found" do
        delete "/v1/users/#{@user.id}/friendships/unfollow", params: {friend_id: 0}
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Couldn't find User with 'id'=0")
      end

      it "return error when friendship not found" do
        delete "/v1/users/#{@user.id}/friendships/unfollow", params: @params
        expect(response).to have_http_status(404)

        errors = JSON.parse(response.body)['errors']
        expect(errors['details']).to include("Friendship not found")
      end
    end
  end

end
