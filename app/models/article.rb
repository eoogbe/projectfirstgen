class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :author, class_name: "User"
  has_many :comments
  validates_presence_of :author, :title, :text
  searchable { text :title, :text }
  
  def self.recent
    order(created_at: :desc).limit(5)
  end
  
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
    text.split(/[\r\n]+/)
  end
  
  def prev_article
    self.class.where("created_at < ?", created_at).order(:created_at).last
  end
  
  def next_article
    self.class.where("created_at > ?", created_at).order(:created_at).first
  end
end
