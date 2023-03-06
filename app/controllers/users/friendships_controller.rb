class Users::FriendshipsController < ApplicationController
  before_action :find_user, :find_friend

  def follow
    @user.friends << @friend
    render json: UserSerializer.new(@user).serialized_json
  end

  def unfollow
    friendship = Friendship.find_by(user_id: @user, friend_id: @friend.id)
    
    if friendship.blank?
      # Use guard clause to optimize, because next line of code won't be executed
      return render_api_error('Friendship not found', 404)
    end

    friendship.destroy
    render json: UserSerializer.new(@user).serialized_json
  end

  private

    def find_user
      @user = User.find(params[:user_id])
    end

    def find_friend
      @friend = User.find(params[:friend_id])
    end
end
