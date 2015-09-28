class Admin::UsersController < AdminController
  def index
    self.users = User.all
  end

  private
  helper_attr :users
end
