class ArticleAuthorizer < ApplicationAuthorizer
  class Scope < ApplicationAuthorizer::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where("author_id = ? OR status = ?", user.id,
          Article.statuses[:approved])
      end
    end
  end

  def create?
    # user && (user.grad? || user.admin?)
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def index?
    user && !user.control?
  end

  def show?
    user && !user.control?
  end

  def search?
    index?
  end

  def approve?
    admin? && record.pending?
  end
end
