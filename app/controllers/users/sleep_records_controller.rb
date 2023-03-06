class Users::SleepRecordsController < ApplicationController
  before_action :find_user

  def index
    clock_times = @user.sleep_records
    render json: SleepRecordSerializer.new(clock_times).serializable_hash.to_json
  end

  private
    def find_user
      @user = User.find(params[:user_id])
    end
end
