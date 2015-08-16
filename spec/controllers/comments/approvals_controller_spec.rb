require 'rails_helper'

RSpec.describe Comments::ApprovalsController do
  Given { sign_in create(:admin) }

  describe "POST #create" do
    Given(:comment) { create(:comment, status: :pending) }
    When(:response) { post :create, comment_id: comment.id }
    Then { comment.reload.approved? }
    Then { expect(response).to redirect_to article_path(comment.article, anchor: "comment-#{comment.id}") }
  end
end
