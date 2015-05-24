class CommentsController < ApplicationController
  def create
    self.article = Article.friendly.find(params[:article_id])
    self.comment = Comment.new(comment_params) do |c|
      c.author = current_user
      c.article = article
    end
    
    if comment.save
      if RaffleService.undergrad(current_user)
        flash.notice = "Congratulations on writing your 3rd question of this month! You have been entered into a raffle whose prize-winner will be announced at the end of the month."
      end
      
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
