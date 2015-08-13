module UnansweredNotifier
  extend self

  def check
    unanswered_comments = Comment.unanswered.where("created_at < ?", 5.days.ago)
    return unless unanswered_comments.exists?

    AdminMailer.unanswered_notification(unanswered_comments).deliver_now
  end
end
