class UsersController < ApplicationController
  def edit
    self.user = User.find(params[:id])
    authorize user
  end

  def update
    self.user = User.find(params[:id])
    authorize user

    if user.update(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    self.user = User.find(params[:id])
    authorize user

    user.destroy
    redirect_to admin_users_path
  end

  private
  helper_attr :user

  def user_params
    params.require(:user).permit(:role, :school, :name, :email)
  end
end
