class RegistrationsController < Devise::RegistrationsController
  before_action :prevent_admin_param, only: :create
  before_action :set_control, only: :create

  private

  def prevent_admin_param
    if params[:user][:role] == "admin"
      redirect_to new_user_registration_path, alert: "You cannot perform that action"
    end
  end

  def set_control
    if params[:user][:role] == "undergrad" && rand < 0.5
      params[:user][:role] = "control"
    end
  end
end
