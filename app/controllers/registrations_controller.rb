require "addressable/uri"

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

  def after_inactive_sign_up_path_for resource
    program = resource.grad? ? "grad" : "ugrad"
    uri = Addressable::URI.parse(ENV["#{resource.school}_#{program}_SURVEY_PATH".upcase])
    uri.query_values = (uri.query_values || {}).merge(confirmation_token: resource.confirmation_token)
    uri.to_s
  end
end
