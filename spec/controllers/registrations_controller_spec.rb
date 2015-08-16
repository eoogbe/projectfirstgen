require 'rails_helper'

RSpec.describe RegistrationsController do
  describe "POST #create" do
    Given { @request.env["devise.mapping"] = Devise.mappings[:user] }
    Given(:user_attrs) { attributes_for(:user).slice(:email, :password, :name) }
    When(:response) { post :create, program: program, user: user_attrs.merge(password_confirmation: user_attrs[:password]) }
    context "when creating grad" do
      Given(:program) { :grad }
      Then { assigns(:user).role == "grad" }
    end
    context "when creating undergrad" do
      Given(:program) { :undergrad }
      Given { allow(subject).to receive(:rand).and_return(0.1) }
      Then { assigns(:user).role == "undergrad" }
    end
    context "when creating control" do
      Given(:program) { :undergrad }
      Given { allow(subject).to receive(:rand).and_return(0.9) }
      Then { assigns(:user).role == "control" }
    end
  end
end
