class Users::ClockInsController < ApplicationController
  before_action :find_user

  def index
    clock_times = ClockTime.where(user_id: @user.id).where.not(clock_in: nil)
    render json: ClockTimeSerializer.new(clock_times).serialized_json
  end

  def create
    # Assume that frontend separate button to clock_in and clock_out.
    # Clock in must be always created.
    # It doesn't need to check error.
    # user_id already checked at find_user.

    clock_time = ClockTime.new(clock_in: clock_time_params[:clock_in], user_id: @user.id)
    if clock_time.save
      render json: ClockTimeSerializer.new(clock_time).serialized_json
    else
      render_api_error(clock_time.errors.full_messages, 400)
    end
  end

  private
    # Using a private method to encapsulate the permissible parameters is
    # a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    
    def clock_time_params
      params.permit(:clock_in, :clock_out)
    end

    def find_user
      @user = User.find(params[:user_id])
    end
end
