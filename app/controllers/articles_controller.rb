class ArticlesController < ApplicationController
  def index
    self.articles = Article.order(created_at: :desc).page(params[:page])
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
      redirect_to article
    else
      render :new
    end
  end
  
  def show
    self.article = Article.friendly.find(params[:id])
  end
  
  private
  helper_attr :articles, :article
  helper_attr :comment  # Needed for a nil check
  
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
