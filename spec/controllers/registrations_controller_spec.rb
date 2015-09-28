require 'rails_helper'

RSpec.describe RegistrationsController do
  describe "POST #create" do
    Given { @request.env["devise.mapping"] = Devise.mappings[:user] }
    When(:response) { post :create, user: { role: role }}
    context "when creating grad" do
      Given(:role) { "grad" }
      Then { assigns(:user).role == "grad" }
      Then { response.successful? }
      Then { flash[:alert].blank? }
    end
    context "when creating undergrad" do
      Given(:role) { "undergrad" }
      Given { allow(subject).to receive(:rand).and_return(0.9) }
      Then { assigns(:user).role == "undergrad" }
      Then { response.successful? }
      Then { flash[:alert].blank? }
    end
    context "when creating control" do
      Given(:role) { "undergrad" }
      Given { allow(subject).to receive(:rand).and_return(0.1) }
      Then { assigns(:user).role == "control" }
      Then { response.successful? }
      Then { flash[:alert].blank? }
    end
    context "when creating admin" do
      Given(:role) { "admin" }
      Then { expect(response).to redirect_to root_path }
      Then { flash[:alert].present? }
    end
  end
end
