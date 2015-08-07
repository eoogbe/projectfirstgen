class CreateRaffleEntries < ActiveRecord::Migration
  def change
    create_table :raffle_entries do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
