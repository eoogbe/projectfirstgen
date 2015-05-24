class ActiveRecord::Base
  def self.policy_class
    "#{name}Authorizer"
  end
end
