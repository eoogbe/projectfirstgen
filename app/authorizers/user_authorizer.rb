class UserAuthorizer < ApplicationAuthorizer
  def update?
    admin? && user != record
  end

  def destroy?
    admin? && user != record
  end
end
