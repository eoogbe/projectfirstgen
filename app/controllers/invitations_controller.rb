class InvitationsController < Devise::InvitationsController
  before_action :require_admin, only: :create
  before_action :set_control, only: :create
end
