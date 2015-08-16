class AdminMailer < ActionMailer::Base
  default from: "projectfirstgen@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.raffle_entry.subject
  #
  def raffle_entry user
    @user = user

    mail to: "nrgracia@stanford.edu"
  end

  def unanswered_notification comments
    @comments = comments

    mail to: "nrgracia@stanford.edu",
      subject: default_i18n_subject(count: comments.count)
  end
end
