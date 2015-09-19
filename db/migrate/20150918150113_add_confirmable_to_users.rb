class AddConfirmableToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at, :confirmation_sent_at
      t.index :confirmation_token, unique: true
    end

    User.reset_column_information
    User.find_each(&:confirm)
  end
end
