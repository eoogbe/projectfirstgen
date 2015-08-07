class CommentsController < ApplicationController
  def create
    self.article = Article.friendly.find(params[:article_id])
    self.comment = Comment.new(comment_params) do |c|
      c.author = current_user
      c.article = article
    end

    if comment.save
      flash[:raffle] = true if current_user.comment_raffle_eligible?

      redirect_to article_path(article, anchor: "comment-#{comment.id}")
    else
      render "articles/show"
    end
  end

  private
  helper_attr :article, :comment

  def comment_params
    params.require(:comment).permit(:text)
  end
end
