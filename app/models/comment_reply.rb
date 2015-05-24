class CommentReply < ActiveRecord::Base
  self.primary_key = :reply_id
  belongs_to :comment
  belongs_to :reply, class_name: "Comment"
  validates_presence_of :comment, :reply
end
