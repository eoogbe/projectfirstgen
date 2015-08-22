class QuestionAuthorizer < ApplicationAuthorizer
  def create?
    user && user.control?
  end
end
