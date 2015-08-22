require 'rails_helper'

RSpec.describe QuestionAuthorizer do

  let(:question) { build(:question) }

  subject { described_class }

  permissions :create? do
    it "grants access when user is an control" do
      user = build(:control)
      expect(subject).to permit(user, question)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, question)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, question)
    end

    it "denies access when user is a admin" do
      user = build(:admin)
      expect(subject).not_to permit(user, question)
    end
  end
end
