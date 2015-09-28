require 'rails_helper'

RSpec.describe UserAuthorizer do

  let(:record) { build(:user) }

  subject { described_class }

  permissions :update?, :edit? do
    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, record)
    end

    it "denies access when record is current user" do
      user = build(:admin)
      expect(subject).not_to permit(user, user)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, record)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, record)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, record)
    end
  end

  permissions :destroy? do
    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, record)
    end

    it "denies access when record is current user" do
      user = build(:admin)
      expect(subject).not_to permit(user, user)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, record)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, record)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, record)
    end
  end
end
