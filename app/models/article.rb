class Article < ActiveRecord::Base
  extend FriendlyId
  include PgSearch
  enum status: [:pending, :approved]
  friendly_id :title, use: :slugged
  pg_search_scope :search_by_title_or_text, against: { title: "A", text: "B" },
    using: { tsearch: { dictionary: "english"}},
    order_within_rank: "articles.created_at DESC"
  belongs_to :author, class_name: "User"
  has_many :comments, dependent: :destroy
  validates_presence_of :author, :title, :text, :status

  def self.recent
    approved.order(created_at: :desc).limit(5)
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

  def prev_article
    self.class.approved
      .where("created_at < ?", created_at)
      .order(:created_at)
      .last
  end

  def next_article
    self.class.approved
      .where("created_at > ?", created_at)
      .order(:created_at)
      .first
  end
end
