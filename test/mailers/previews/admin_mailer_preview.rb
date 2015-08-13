class AdminMailerPreview < ActionMailer::Preview
  def unanswered_notification
    AdminMailer.unanswered_notification(Comment.limit(3))
  end

  def raffle_entry
    AdminMailer.raffle_entry(User.first)
  end
end
