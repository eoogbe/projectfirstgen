class QuestionsController < ApplicationController
  def new
    self.question = Question.new
    authorize question
  end

  def create
    self.question = Question.new(question_params) do |q|
      q.author = current_user
    end
    authorize question

    if question.save
      if current_user.question_raffle_eligible?
        flash[:raffle] = true
      elsif current_user.current_raffle_entry.nil?
        num_questions = current_user.num_questions_needed_for_raffle
        flash.notice = "#{num_questions} more #{"question".pluralize(num_questions)} until you are eligible for the monthly raffle"
      end

      redirect_to resources_path
    else
      render :new
    end
  end

  private
  helper_attr :question

  def question_params
    params.require(:question).permit(:text)
  end
end
