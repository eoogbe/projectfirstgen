class Comment < ActiveRecord::Base
  enum status: [:pending, :approved]
  belongs_to :author, class_name: "User"
  belongs_to :article
  has_many :comment_replies
  has_many :replies, ->{ order(:created_at) }, through: :comment_replies
  has_one :reply_parent, foreign_key: :reply_id, class_name: "CommentReply"
  has_one :parent, through: :reply_parent, source: :comment
  validates_presence_of :author, :article, :text, :status
  delegate :title, to: :article, prefix: true

  def self.recent
    approved.order(created_at: :desc).limit(5)
  end

  def self.unanswered
    where("id NOT IN (SELECT reply_id FROM comment_replies)")
      .where("id NOT IN (SELECT comment_id FROM comment_replies)")
  end

  def author_name
    author.username
  end

  def root?
    parent.nil?
  end

  def old_unanswered?
    root? && replies.count == 0 && created_at > 5.days.ago
  end

  def paragraphs
    text.split(/[\r\n]+/)
  end
end
