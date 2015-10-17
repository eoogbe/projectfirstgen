require 'rails_helper'

RSpec.describe Admin::ConfirmationsController do
  Given { sign_in create(:admin) }

  describe "POST #create" do
    Given(:user) { create(:user, confirm: false) }
    When(:response) { post :create, user_id: user.id }
    Then { user.reload.confirmed? }
    Then { expect(response).to redirect_to admin_users_path }
  end
end
