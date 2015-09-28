require "addressable/uri"

class RegistrationsController < Devise::RegistrationsController
  before_action :prevent_admin_param, only: :create
  before_action :set_control, only: :create

  private

  def prevent_admin_param
    user_not_authorized if params[:user][:role] == "admin"
  end

  def after_inactive_sign_up_path_for resource
    program = resource.grad? ? "grad" : "ugrad"
    uri = Addressable::URI.parse(ENV["#{resource.school}_#{program}_SURVEY_PATH".upcase])
    uri.query_values = (uri.query_values || {}).merge(confirmation_token: resource.confirmation_token)
    uri.to_s
  end
end
