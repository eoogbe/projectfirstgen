class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :author, index: true
      t.text :text

      t.timestamps
    end
  end
end
