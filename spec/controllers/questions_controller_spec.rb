require 'rails_helper'

RSpec.describe QuestionsController do
  Given(:current_user) { create(:control) }
  Given { sign_in current_user }

  describe "GET #new" do
    When(:response) { get :new }
    Then { expect(assigns(:question)).to be_a_new Question }
    Then { expect(response).to render_template :new }
    Then { response.successful? }
  end

  describe "POST #create" do
    When(:response) { post :create, question: question_attrs }
    context "when valid" do
      Given(:question_attrs) { attributes_for(:question).slice(:text) }
      Then { assigns(:question).persisted? }
      Then { expect(response).to redirect_to resources_path }
      context "when questions needed to be eligible for raffle" do
        Then { flash[:raffle].nil? }
        Then { flash.notice.present? }
      end
      context "when raffle eligible" do
        Given { create_pair(:question, author: current_user) }
        Then { flash[:raffle] == true }
        Then { flash.notice.nil? }
      end
      context "when already entered raffle" do
        Given { create_list(:question, 3, author: current_user) }
        Given { current_user.raffle_entries.create! }
        Then { flash[:raffle].nil? }
        Then { flash.notice.nil? }
      end
    end
    context "when invalid" do
      Given(:question_attrs) { { text: "" } }
      Then { expect(assigns(:question)).to be_a_new Question }
      Then { expect(response).to render_template :new }
    end
  end
end
