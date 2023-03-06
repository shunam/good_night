class Users::ClockOutsController < ApplicationController
  before_action :find_user
  before_action :validate_presence_id_or_clock_out, except: :index

  def index
    clock_times = ClockTime.where(user_id: @user.id)
                           .where.not(clock_out: nil)
                           .page(clock_time_params[:page])
    render json: ClockTimeSerializer.new(clock_times, 
      generate_links(
        clock_times,
        users_clock_outs_url(@user.id),
        clock_time_params[:page].to_i
      )
    ).serializable_hash.to_json
  end

  def update
    # Assume that frontend separate button to clock_in and clock_out.
    # Clock in must be always created.
    # It doesn't need to check error.
    # user_id already checked at find_user.

    last_clock_in = ClockTime.last_clock_in(
      id: clock_time_params[:id], #optional between id or clock_out
      clock_out: clock_time_params[:clock_out], #optional between id or clock_out
      user_id: @user.id
    )

    if last_clock_in.clock_out.blank?
      last_clock_in.update_attribute(:clock_out, clock_time_params[:clock_out])
      render json: ClockTimeSerializer.new(last_clock_in).serializable_hash.to_json
    else
      render_api_error('Clock out already exist', 400)
    end
  end

  private
    # Using a private method to encapsulate the permissible parameters is
    # a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    
    def clock_time_params
      params.permit(:id, :clock_out, :page)
    end

    def find_user
      @user = User.find(params[:user_id])
    end

    def validate_presence_id_or_clock_out
      if params[:id].blank? and params[:clock_out].blank?
        render_api_error('ID or clock out must not be empty', 400)
      end
    end
end
