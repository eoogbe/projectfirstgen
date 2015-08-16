class RepliesController < ApplicationController
  def new
    self.comment = Comment.find(params[:comment_id])
    self.reply = comment.replies.build

    if request.xhr?
      render partial: "replies/form", locals: { comment: comment, reply: reply }
    end
  end

  def create
    self.comment = Comment.find(params[:comment_id])
    self.reply = Comment.new(reply_params) do |c|
      c.author = current_user
      c.parent = comment
      c.article = comment.article
      c.status = current_user.admin? ? :approved : :pending
    end

    if reply.save
      if current_user.comment_raffle_eligible?
        flash[:raffle] = true
      elsif current_user.undergrad? && current_user.current_raffle_entry.nil?
        num_comments = current_user.num_comments_needed_for_raffle
        flash.notice = "#{num_comments} more #{"question".pluralize(num_comments)} until you are eligible for the monthly raffle"
      end

      redirect_to article_path(reply.article, anchor: "comment-#{reply.id}")
    else
      render :new
    end
  end

  private
  helper_attr :comment, :reply

  def reply_params
    params.require(:reply).permit(:text)
  end
end
