class Admin::ConfirmationsController < AdminController
  def create
    User.find(params[:user_id]).confirm

    redirect_to admin_users_path
  end
end
