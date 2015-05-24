module RaffleService
  def grad user
    user.grad? && user.num_current_articles == 3
  end
  
  def undergrad user
    user.undergrad? && user.num_current_comments == 3
  end
  
  extend self
end
