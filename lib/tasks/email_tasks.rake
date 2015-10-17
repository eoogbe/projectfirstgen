require 'unanswered_notifier'
require 'reminder_sender'

desc "Send notification about unanswered comments"
task unanswered_notification: :environment do
  UnansweredNotifier.check
end

task reminder_emails: :environment do
  ReminderSender.send
end
