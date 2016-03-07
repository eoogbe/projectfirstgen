require 'rails_helper'

RSpec.describe RepliesController do
  Given { sign_in current_user }

  describe "GET #new" do
    Given(:current_user) { create(:admin) }
    Given(:comment) { create(:comment) }
    When(:response) { get :new, comment_id: comment.id }
    Then { assigns(:comment) == comment }
    Then { expect(assigns(:reply)).to be_a_new Comment }
    Then { expect(response).to render_template :new }
    Then { response.successful? }
  end

  describe "POST #create" do
    Given(:comment) { create(:comment) }
    When(:response) { post :create, comment_id: comment.id, reply: reply_attrs }
    # context "when current user is undergrad" do
    #   Given(:current_user) { create(:user) }
    #   context "when valid" do
    #     Given(:reply_attrs) { attributes_for(:comment).slice(:text) }
    #     Then { assigns(:comment) == comment }
    #     Then { assigns(:reply).persisted? }
    #     Then { assigns(:reply).pending? }
    #     Then { assigns(:reply).parent == comment }
    #     Then { expect(response).to redirect_to article_path(comment.article, anchor: "comment-#{assigns(:reply).id}") }
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
    #     Given(:reply_attrs) { { text: "" } }
    #     Then { expect(assigns(:reply)).to be_a_new Comment }
    #     Then { expect(response).to render_template :new }
    #   end
    # end
    # context "when current user is grad" do
    #   Given(:current_user) { create(:grad) }
    #   Given(:reply_attrs) { attributes_for(:comment).slice(:text) }
    #   Then { assigns(:reply).pending? }
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
      Given(:reply_attrs) { attributes_for(:comment).slice(:text) }
      Then { assigns(:reply).approved? }
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
end
