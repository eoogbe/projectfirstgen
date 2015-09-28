require 'rails_helper'

RSpec.describe Articles::ApprovalsController do
  Given { sign_in create(:admin) }

  describe "POST #create" do
    Given(:article) { create(:article, status: :pending) }
    When(:response) { post :create, article_id: article.to_param }
    Then { article.reload.approved? }
    Then { expect(response).to redirect_to article_path(article) }
  end
end
