require 'rails_helper'

RSpec.describe CommentsController do
  Given { sign_in current_user }

  describe "POST #create" do
    Given(:article) { create(:article) }
    When(:response) { post :create, article_id: article.to_param, comment: comment_attrs }
    # context "when current user is undergrad" do
    #   Given(:current_user) { create(:user) }
    #   context "when valid" do
    #     Given(:comment_attrs) { attributes_for(:comment).slice(:text) }
    #     Then { assigns(:article) == article }
    #     Then { assigns(:comment).persisted? }
    #     Then { assigns(:comment).pending? }
    #     Then { expect(response).to redirect_to article_path(article, anchor: "comment-#{assigns(:comment).id}") }
    #     context "when comments needed to be eligible for raffle" do
    #       Then { flash[:raffle].nil? }
    #       Then { flash.notice.present? }
    #     end
    #     context "when raffle eligible" do
    #       Given { create_pair(:comment, author: current_user) }
    #       Then { flash[:raffle] == true }
    #       Then { flash.notice.nil? }
    #     end
    #     context "when already entered raffle" do
    #       Given { create_list(:comment, 3, author: current_user) }
    #       Given { current_user.raffle_entries.create! }
    #       Then { flash[:raffle].nil? }
    #       Then { flash.notice.nil? }
    #     end
    #   end
    #   context "when invalid" do
    #     Given(:comment_attrs) { { text: "" } }
    #     Then { expect(assigns(:comment)).to be_a_new Comment }
    #     Then { expect(response).to render_template "articles/show" }
    #   end
    # end
    # context "when current user is grad" do
    #   Given(:current_user) { create(:grad) }
    #   Given(:comment_attrs) { attributes_for(:comment).slice(:text) }
    #   Then { assigns(:comment).pending? }
    #   context "when has 0 comments for the month" do
    #     Then { flash[:raffle].nil? }
    #     Then { flash.notice.nil? }
    #   end
    #   context "when has 2 comments for the month" do
    #     Given { create_pair(:comment, author: current_user) }
    #     Then { flash[:raffle].nil? }
    #     Then { flash.notice.nil? }
    #   end
    # end
    context "when current user is admin" do
      Given(:current_user) { create(:admin) }
      Given(:comment_attrs) { attributes_for(:comment).slice(:text) }
      Then { assigns(:comment).approved? }
      context "when has 0 comments for the month" do
        Then { flash[:raffle].nil? }
        Then { flash.notice.nil? }
      end
      context "when has 2 comments for the month" do
        Given { create_pair(:comment, author: current_user) }
        Then { flash[:raffle].nil? }
        Then { flash.notice.nil? }
      end
    end
  end

  describe "GET #edit" do
    Given(:current_user) { create(:admin) }
    Given(:comment) { create(:comment) }
    When(:response) { get :edit, id: comment.id }
    Then { assigns(:comment) == comment }
    Then { expect(response).to render_template :edit }
    Then { response.successful? }
  end

  describe "PUT #update" do
    Given(:current_user) { create(:admin) }
    Given(:comment) { create(:comment) }
    When(:response) { put :update, id: comment.id, comment: comment_attrs }
    context "when valid" do
      Given(:comment_attrs) { attributes_for(:comment).slice(:text) }
      Then { expect(response).to redirect_to article_path(comment.article, anchor: "comment-#{comment.id}") }
    end
    context "when invalid" do
      Given(:comment_attrs) { { text: "" } }
      Then { expect(response).to render_template :edit }
    end
  end

  describe "DELETE #destroy" do
    Given(:current_user) { create(:admin) }
    Given(:comment) { create(:comment) }
    When(:response) { delete :destroy, id: comment.id }
    Then { expect(response).to redirect_to dashboard_path }
    Then { !Comment.exists?(id: comment.id) }
  end
end
