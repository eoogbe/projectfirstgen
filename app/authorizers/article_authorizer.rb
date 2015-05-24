class ArticleAuthorizer < ApplicationAuthorizer
  def create?
    user.grad?
  end
end
