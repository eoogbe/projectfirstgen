class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :author, class_name: "User"
  has_many :comments
  validates_presence_of :author, :title, :text
  
  def root_comments
    comments
      .includes(:parent, :replies)
      .where("id NOT IN (SELECT reply_id FROM comment_replies)")
      .order(created_at: :desc)
  end
  
  def author_name
    author.username
  end
  
  def paragraphs
    @paragraphs ||= text.split("\n")
  end
  
  def prev_article
    self.class.where("created_at < ?", created_at).order(:created_at).last
  end
  
  def next_article
    self.class.where("created_at > ?", created_at).order(:created_at).first
  end
end
