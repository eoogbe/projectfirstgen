class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def self.helper_attr *attrs
    attr_accessor(*attrs)
    helper_method(*attrs)
  end

  def after_sign_out_path_for resource
    new_user_session_path
  end

  def after_invite_path_for resource
    admin_users_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).concat [:name, :school, :role]
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:invite).concat [:name, :school, :role]
  end

  def require_admin
    user_not_authorized unless current_user && current_user.admin?
  end

  def set_control
    if params[:user][:role] == "undergrad" && rand < 0.5
      params[:user][:role] = "control"
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform that action."
    redirect_to(request.referrer || root_path)
  end
end
