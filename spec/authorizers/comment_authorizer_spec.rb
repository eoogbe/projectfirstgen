require 'rails_helper'

RSpec.describe CommentAuthorizer do

  let(:comment) { create(:comment) }

  subject { described_class }

  permissions ".scope" do
    it "shows approved comments" do
      user = build(:user)
      scope = subject.new(user, comment).scope
      expect(scope).to include comment
    end

    it "doesn't show pending comments" do
      user = build(:user)
      pending = create(:comment, status: :pending)
      scope = subject.new(user, comment).scope
      expect(scope).not_to include pending
    end

    it "shows pending comments created by the user" do
      user = build(:user)
      pending = create(:comment, author: user, status: :pending)
      scope = subject.new(user, comment).scope
      expect(scope).to include pending
    end

    it "shows pending comments to admins" do
      user = build(:admin)
      pending = create(:comment, status: :pending)
      scope = subject.new(user, comment).scope
      expect(scope).to include pending
    end
  end

  permissions :create? do
    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, comment)
    end

    it "grants access when user is a grad" do
      user = build(:grad)
      expect(subject).to permit(user, comment)
    end

    it "grants access when user is an undergrad" do
      user = build(:user)
      expect(subject).to permit(user, comment)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, comment)
    end
  end

  permissions :update?, :edit? do
    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, comment)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, comment)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, comment)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, comment)
    end
  end

  permissions :destroy? do
    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, comment)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, comment)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, comment)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, comment)
    end
  end

  permissions :approve? do
    it "grants access when user is an admin and comment is pending" do
      comment.pending!
      user = build(:admin)
      expect(subject).to permit(user, comment)
    end

    it "denies access when comment is approved" do
      user = build(:admin)
      expect(subject).not_to permit(user, comment)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, comment)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, comment)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, comment)
    end
  end
end
