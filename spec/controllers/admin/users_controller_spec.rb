require 'rails_helper'

RSpec.describe Admin::UsersController do
  Given(:current_user) { create(:admin) }
  Given { sign_in current_user }

  describe "GET #index" do
    When(:response) { get :index }
    Then { expect(assigns(:users)).to match_array [current_user] }
    Then { expect(response).to render_template :index }
    Then { response.successful? }
  end
end
