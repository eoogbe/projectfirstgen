class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :text, null: false
      t.string :slug, null: false
      t.index :slug, unique: true
      t.references :author, index: true, null: false

      t.timestamps
    end
  end
end
