class Admin::CommentsController < AdminController
  def index
    self.comments = Comment.order(:status, created_at: :desc)
  end

  private
  helper_attr :comments
end
