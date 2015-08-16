require 'rails_helper'

RSpec.describe Admin::CommentsController do
  Given { sign_in create(:admin) }

  describe "GET #index" do
    Given(:comment) { create(:comment, status: :pending) }
    When(:response) { get :index }
    Then { expect(assigns(:comments)).to match_array [comment] }
    Then { expect(response).to render_template :index }
    Then { response.successful? }
  end
end
