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

  describe "GET #edit" do
    Given(:user) { create(:user) }
    When(:response) { get :edit, id: user.id }
    Then { assigns(:user) == user }
    Then { expect(response).to render_template :edit }
    Then { response.successful? }
  end

  describe "PUT #update" do
    Given(:user) { create(:user) }
    When(:response) { put :update, id: user.id, user: user_attrs }
    context "when valid" do
      Given(:user_attrs) { attributes_for(:user).slice(:name, :email, :role) }
      Then { expect(response).to redirect_to admin_users_path }
    end
    context "when invalid" do
      Given(:user_attrs) { { name: "", email: "" } }
      Then { expect(response).to render_template :edit }
    end
  end

  describe "DELETE #destroy" do
    Given(:user) { create(:user) }
    When(:response) { delete :destroy, id: user.id }
    Then { expect(response).to redirect_to admin_users_path }
    Then { !User.exists?(id: user.id) }
  end

  describe "GET #show" do
    Given(:user) { create(:user) }
    When(:response) { get :show, id: user.id }
    Then { assigns(:user) == user }
    Then { expect(response).to render_template :show }
    Then { response.successful? }
  end
end
