class Admin::UsersController < AdminController
  def index
    self.users = User.all
  end

  def edit
    self.user = User.find(params[:id])
  end

  def update
    self.user = User.find(params[:id])
    if user.update(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  private
  helper_attr :users, :user

  def user_params
    params.require(:user).permit(:role, :school, :name, :email)
  end
end
