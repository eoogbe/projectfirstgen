class ArticlesController < ApplicationController
  def index
    self.articles = Article.order(created_at: :desc).page(params[:page])
    authorize articles
  end
  
  def new
    self.article = Article.new
    authorize article
  end
  
  def create
    self.article = Article.new(article_params) do |a|
      a.author = current_user
    end
    authorize article
    
    if article.save
      if RaffleService.grad(current_user)
        flash.notice = "Congratulations on writing your 3rd blog post of this month! You have been entered into a raffle whose prize-winner will be announced at the end of the month."
      end
      
      redirect_to article
    else
      render :new
    end
  end
  
  def show
    self.article = Article.friendly.find(params[:id])
    authorize article
  end
  
  private
  helper_attr :articles, :article
  helper_attr :comment  # Needed for a nil check
  
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
