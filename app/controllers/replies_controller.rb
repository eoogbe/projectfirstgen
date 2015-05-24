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
      c.parent = comment
      c.author = current_user
      c.article = comment.article
    end
    
    if reply.save
      if request.xhr?
        render reply
      else
        redirect_to article_path(reply.article, anchor: "comment-#{reply.id}")
      end
    else
      if request.xhr?
        render partial: "replies/form", status: :unprocessable_entity,
          locals: { comment: comment, reply: reply }
      else
        render :new
      end
    end
  end
  
  private
  helper_attr :comment, :reply
  
  def reply_params
    params.require(:reply).permit(:text)
  end
end
