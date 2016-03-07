require 'rails_helper'

RSpec.describe ArticlesController do
  Given { sign_in current_user }

  describe "GET #index" do
    Given(:current_user) { create(:user) }
    Given(:article) { create(:article) }
    When(:response) { get :index }
    Then { expect(assigns(:articles)).to match_array [article] }
    Then { expect(response).to render_template :index }
    Then { response.successful? }
  end

  describe "GET #new" do
    Given(:current_user) { create(:admin) }
    When(:response) { get :new }
    Then { expect(assigns(:article)).to be_a_new Article }
    Then { expect(response).to render_template :new }
    Then { response.successful? }
  end

  describe "POST #create" do
    When(:response) { post :create, article: article_attrs }
    # context "when current user is grad" do
    #   Given(:current_user) { create(:grad) }
    #   context "when valid" do
    #     Given(:article_attrs) { attributes_for(:article).slice(:title, :text) }
    #     Then { assigns(:article).persisted? }
    #     Then { assigns(:article).pending? }
    #     Then { expect(response).to redirect_to article_path(assigns(:article)) }
    #     context "when articles needed to be eligible for raffle" do
    #       Then { flash[:raffle].nil? }
    #       Then { flash.notice.present? }
    #     end
    #     context "when raffle eligible" do
    #       Given { create_pair(:article, author: current_user) }
    #       Then { flash[:raffle] == true }
    #       Then { flash.notice.nil? }
    #     end
    #     context "when already entered raffle" do
    #       Given { create_list(:article, 3, author: current_user) }
    #       Given { current_user.raffle_entries.create! }
    #       Then { flash[:raffle].nil? }
    #       Then { flash.notice.nil? }
    #     end
    #   end
    #   context "when invalid" do
    #     Given(:article_attrs) { { title: "", text: "" } }
    #     Then { expect(assigns(:article)).to be_a_new Article }
    #     Then { expect(response).to render_template :new }
    #   end
    # end
    context "when current user is admin" do
      Given(:current_user) { create(:admin) }
      Given(:article_attrs) { attributes_for(:article).slice(:title, :text) }
      Then { assigns(:article).approved? }
      context "when has 0 articles for the month" do
        Then { flash[:raffle].nil? }
        Then { flash.notice.nil? }
      end
      context "when has 2 articles for the month" do
        Given { create_pair(:article, author: current_user) }
        Then { flash[:raffle].nil? }
        Then { flash.notice.nil? }
      end
    end
  end

  describe "GET #edit" do
    Given(:current_user) { create(:admin) }
    Given(:article) { create(:article) }
    When(:response) { get :edit, id: article.to_param }
    Then { assigns(:article) == article }
    Then { expect(response).to render_template :edit }
    Then { response.successful? }
  end

  describe "PUT #update" do
    Given(:current_user) { create(:admin) }
    Given(:article) { create(:article) }
    When(:response) { put :update, id: article.to_param, article: article_attrs }
    context "when valid" do
      Given(:article_attrs) { attributes_for(:article).slice(:title, :text) }
      Then { expect(response).to redirect_to article_path(article) }
    end
    context "when invalid" do
      Given(:article_attrs) { { title: "", text: "" } }
      Then { expect(response).to render_template :edit }
    end
  end

  describe "GET #show" do
    Given(:current_user) { create(:user) }
    Given(:article) { create(:article) }
    When(:response) { get :show, id: article.to_param }
    Then { assigns(:article) == article }
    Then { expect(response).to render_template :show }
    Then { response.successful? }
  end

  describe "DELETE #destroy" do
    Given(:current_user) { create(:admin) }
    Given(:article) { create(:article) }
    When(:response) { delete :destroy, id: article.to_param }
    Then { expect(response).to redirect_to dashboard_path }
    Then { !Article.exists?(id: article.id) }
  end

  describe "GET #search" do
    Given(:current_user) { create(:user) }
    Given(:article) { create(:article, title: "Practical Rubber Computer") }
    When(:response) { get :search, q: "computer" }
    Then { expect(assigns(:articles)).to match_array [article] }
    Then { expect(response).to render_template :search }
    Then { response.successful? }
  end
end
