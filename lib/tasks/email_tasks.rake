desc "Send notification about unanswered comments"
task unanswered_notification: :environment do
  UnansweredNotifier.check
end
