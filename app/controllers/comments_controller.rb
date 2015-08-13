class CommentsController < ApplicationController
  def create
    self.article = Article.friendly.find(params[:article_id])
    self.comment = Comment.new(comment_params) do |c|
      c.author = current_user
      c.article = article
      c.status = current_user.admin? ? :approved : :pending
    end

    if comment.save
      flash[:raffle] = true if current_user.comment_raffle_eligible?

      redirect_to article_path(article, anchor: "comment-#{comment.id}")
    else
      render "articles/show"
    end
  end

  def edit
    self.comment = Comment.find(params[:id])
    authorize comment
  end

  def update
    self.comment = Comment.find(params[:id])
    authorize comment

    if comment.update(comment_params)
      redirect_to article_path(comment.article, anchor: "comment-#{comment.id}")
    else
      render :edit
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    authorize comment

    comment.destroy

    redirect_to dashboard_path
  end

  private
  helper_attr :article, :comment

  def comment_params
    params.require(:comment).permit(:text)
  end
end
