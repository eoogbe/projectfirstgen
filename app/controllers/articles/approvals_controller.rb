class Articles::ApprovalsController < ApplicationController
  def create
    article = Article.friendly.find(params[:article_id])
    authorize article, :approve?

    article.approved!

    redirect_to article
  end
end
