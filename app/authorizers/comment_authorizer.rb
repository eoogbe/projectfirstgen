class CommentAuthorizer < ApplicationAuthorizer
  class Scope < ApplicationAuthorizer::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where("author_id = ? OR status = ?", user.id,
          Comment.statuses[:approved])
      end
    end
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def approve?
    admin? && record.pending?
  end
end
