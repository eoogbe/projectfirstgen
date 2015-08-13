class Admin::ArticlesController < AdminController
  def index
    self.articles = Article.order(:status, created_at: :desc)
  end

  private
  helper_attr :articles
end
