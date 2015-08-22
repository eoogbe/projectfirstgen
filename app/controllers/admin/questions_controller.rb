class Admin::QuestionsController < AdminController
  def index
    self.questions = Question.order(created_at: :desc)
  end

  private
  helper_attr :questions
end
