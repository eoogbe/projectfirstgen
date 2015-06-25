class AddNameToUsers < ActiveRecord::Migration
  def change
    remove_index :users, :username
    remove_column :users, :username, :string
    add_column :users, :name, :string
  end
end
