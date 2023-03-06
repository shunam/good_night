class Users::SleepRecordsController < ApplicationController
  before_action :find_user

  def index
    clock_times = @user.sleep_records.page(sleep_records_params[:page])
    render json: SleepRecordSerializer.new(clock_times, 
      generate_links(
        clock_times,
        users_sleep_records_url(@user.id),
        sleep_records_params[:page].to_i
      )
    ).serializable_hash.to_json
  end

  private
    # Using a private method to encapsulate the permissible parameters is
    # a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def sleep_records_params
      params.permit(:page)
    end

    def find_user
      @user = User.find(params[:user_id])
    end
end
