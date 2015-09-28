require 'rails_helper'

RSpec.describe ArticleAuthorizer do

  let(:article) { create(:article) }

  subject { described_class }

  permissions ".scope" do
    it "shows approved articles" do
      user = build(:user)
      scope = subject.new(user, article).scope
      expect(scope).to include article
    end

    it "doesn't show pending articles" do
      user = build(:user)
      pending = create(:article, status: :pending)
      scope = subject.new(user, article).scope
      expect(scope).not_to include pending
    end

    it "shows pending articles created by the user" do
      user = build(:grad)
      pending = create(:article, author: user, status: :pending)
      scope = subject.new(user, article).scope
      expect(scope).to include pending
    end

    it "shows pending articles to admins" do
      user = build(:admin)
      pending = create(:article, status: :pending)
      scope = subject.new(user, article).scope
      expect(scope).to include pending
    end
  end

  permissions :index? do
    it "grants access when user is an undergrad" do
      user = build(:user)
      expect(subject).to permit(user, article)
    end

    it "grants access when user is a grad" do
      user = build(:grad)
      expect(subject).to permit(user, article)
    end

    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, article)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, article)
    end
  end

  permissions :show? do
    it "grants access when user is an undergrad" do
      user = build(:user)
      expect(subject).to permit(user, article)
    end

    it "grants access when user is a grad" do
      user = build(:grad)
      expect(subject).to permit(user, article)
    end

    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, article)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, article)
    end
  end

  permissions :create?, :new? do
    it "grants access when user is a grad" do
      user = build(:grad)
      expect(subject).to permit(user, article)
    end

    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, article)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, article)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, article)
    end
  end

  permissions :update?, :edit? do
    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, article)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, article)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, article)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, article)
    end
  end

  permissions :destroy? do
    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, article)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, article)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, article)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, article)
    end
  end

  permissions :search? do
    it "grants access when user is an undergrad" do
      user = build(:user)
      expect(subject).to permit(user, article)
    end

    it "grants access when user is a grad" do
      user = build(:grad)
      expect(subject).to permit(user, article)
    end

    it "grants access when user is an admin" do
      user = build(:admin)
      expect(subject).to permit(user, article)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, article)
    end
  end

  permissions :approve? do
    it "grants access when user is an admin and article is pending" do
      article.pending!
      user = build(:admin)
      expect(subject).to permit(user, article)
    end

    it "denies access when article is approved" do
      user = build(:admin)
      expect(subject).not_to permit(user, article)
    end

    it "denies access when user is an undergrad" do
      user = build(:user)
      expect(subject).not_to permit(user, article)
    end

    it "denies access when user is a grad" do
      user = build(:grad)
      expect(subject).not_to permit(user, article)
    end

    it "denies access when user is a control" do
      user = build(:control)
      expect(subject).not_to permit(user, article)
    end
  end
end
