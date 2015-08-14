class ArticlesController < ApplicationController
  def index
    self.articles = policy_scope(Article)
      .order(created_at: :desc)
      .page(params[:page])
    authorize articles
  end

  def new
    self.article = Article.new
    authorize article
  end

  def create
    self.article = Article.new(article_params) do |a|
      a.author = current_user
      a.status = current_user.admin? ? :approved : :pending
    end
    authorize article

    if article.save
      flash[:raffle] = true if current_user.article_raffle_eligible?

      redirect_to article
    else
      render :new
    end
  end

  def edit
    self.article = Article.friendly.find(params[:id])
    authorize article
  end

  def update
    self.article = Article.friendly.find(params[:id])
    authorize article

    if article.update(article_params)
      redirect_to article
    else
      render :edit
    end
  end

  def show
    self.article = Article.friendly.find(params[:id])
    authorize article
  end

  def destroy
    article = Article.friendly.find(params[:id])
    authorize article

    article.destroy
    redirect_to dashboard_path
  end

  def search
    return redirect_to articles_path if params[:q].blank?

    authorize Article.new
    self.articles = policy_scope(Article)
      .search_by_title_or_text(params[:q])
      .page(params[:page])
  end

  private
  helper_attr :articles, :article
  helper_attr :comment  # Needed for a nil check

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
