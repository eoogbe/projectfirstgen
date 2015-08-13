class AdminController < ApplicationController
  before_action :require_admin
  layout "admin"

  private

  def require_admin
    unless current_user && current_user.admin?
      redirect_to root_path, alert: "You are not authorized to perform that action"
    end
  end
end
