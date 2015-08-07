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
      flash[:raffle] = true if current_user.article_raffle_eligible?

      redirect_to article
    else
      render :new
    end
  end

  def show
    self.article = Article.friendly.find(params[:id])
    authorize article
  end

  def search
    return redirect_to articles_path if params[:q].blank?

    authorize Article.new
    self.articles = Article.search do
      fulltext params[:q] do
        boost_fields title: 2.0
      end
      paginate page: params[:page], per_page: Kaminari.config.default_per_page
    end.results
  end

  private
  helper_attr :articles, :article
  helper_attr :comment  # Needed for a nil check

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
