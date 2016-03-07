class QuestionAuthorizer < ApplicationAuthorizer
  def create?
    # user && user.control?
    false
  end
end
