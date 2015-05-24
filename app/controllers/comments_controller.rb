class CommentsController < ApplicationController
  def create
    self.article = Article.friendly.find(params[:article_id])
    self.comment = Comment.new(comment_params) do |c|
      c.author = current_user
      c.article = article
    end
    
    if comment.save
      if request.xhr?
        render comment
      else
        redirect_to article_path(article, anchor: "comment-#{comment.id}")
      end
    else
      if request.xhr?
        render partial: "comments/form", status: :unprocessable_entity,
          locals: { article: article, comment: comment }
      else
        render "articles/show"
      end
    end
  end
  
  private
  helper_attr :article, :comment
  
  def comment_params
    params.require(:comment).permit(:text)
  end
end
