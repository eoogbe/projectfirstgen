class Comment < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :article
  has_many :comment_replies
  has_many :replies, ->{ order(:created_at) }, through: :comment_replies
  has_one :reply_parent, foreign_key: :reply_id, class_name: "CommentReply"
  has_one :parent, through: :reply_parent, source: :comment
  validates_presence_of :author, :article, :text
  
  def self.recent
    order(created_at: :desc).limit(5)
  end
  
  def author_name
    author.username
  end
  
  def root?
    parent.nil?
  end
  
  def paragraphs
    text.split(/[\r\n]+/)
  end
end
