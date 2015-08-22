module ReminderSender
  extend self

  def send
    users.find_each do |user|
      case user.role
      when "undergrad"
        if user.num_comments_needed_for_raffle > 0
          UserMailer.undergrad_reminder(user).deliver
        end
      when "grad"
        if user.num_articles_needed_for_raffle > 0
          UserMailer.grad_reminder(user).deliver
        end
      when "control"
        if user.num_questions_needed_for_raffle > 0
          UserMailer.control_reminder(user).deliver
        end
      end
    end
  end

  private

  def users
    if Article.exists?
      User.where.not(role: User.roles[:admin])
    else
      User.where(role: User.roles.values_at(:grad, :control))
    end
  end
end
