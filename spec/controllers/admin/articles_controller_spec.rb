require 'rails_helper'

RSpec.describe Admin::ArticlesController do
  Given { sign_in create(:admin) }

  describe "GET #index" do
    Given(:article) { create(:article, status: :pending) }
    When(:response) { get :index }
    Then { expect(assigns(:articles)).to match_array [article] }
    Then { expect(response).to render_template :index }
    Then { response.successful? }
  end
end
