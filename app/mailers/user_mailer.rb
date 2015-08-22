class UserMailer < ActionMailer::Base
  default from: "Project First-Gen <projectfirstgen@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.undergrad_reminder.subject
  #
  def undergrad_reminder user
    @user = user

    mail to: user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.grad_reminder.subject
  #
  def grad_reminder user
    @user = user

    mail to: user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.control_reminder.subject
  #
  def control_reminder user
    @user = user

    mail to: user.email
  end
end
