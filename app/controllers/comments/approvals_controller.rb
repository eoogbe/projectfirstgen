class Comments::ApprovalsController < ApplicationController
  def create
    comment = Comment.find(params[:comment_id])
    authorize comment, :approve?

    comment.approved!

    redirect_to article_path(comment.article, anchor: "comment-#{comment.id}")
  end
end
