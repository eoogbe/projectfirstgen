class CreateCommentReplies < ActiveRecord::Migration
  def change
    create_table :comment_replies, id: false do |t|
      t.primary_key :reply_id
      t.references :comment, index: true, null: false

      t.timestamps
    end
  end
end
