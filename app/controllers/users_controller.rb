class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  
  def show
    if user = User.find_by(username: params[:username])
      render json: user
    else
      render nothing: true, status: :not_found
    end
  end
end
