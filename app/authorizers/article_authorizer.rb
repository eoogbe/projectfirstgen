class ArticleAuthorizer < ApplicationAuthorizer
  def create?
    user && user.grad?
  end
  
  def index?
    user && !user.control?
  end
  
  def show?
    user && !user.control?
  end
end
