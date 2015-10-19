# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/undergrad_reminder
  def undergrad_reminder
    UserMailer.undergrad_reminder(User.undergrad.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/grad_reminder
  def grad_reminder
    UserMailer.grad_reminder(User.grad.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/control_reminder
  def control_reminder
    UserMailer.control_reminder(User.control.first)
  end

end
