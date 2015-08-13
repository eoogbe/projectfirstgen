class User < ActiveRecord::Base
  NUM_PUBLICATIONS_FOR_RAFFLE = 3
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:undergrad, :grad, :control, :admin]
  has_many :articles, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id
  has_many :raffle_entries
  validates_presence_of :role, :name
  validates_uniqueness_of :username
  after_create :add_username

  def current_articles
    articles.where("created_at > ?", DateTime.now.beginning_of_month)
  end

  def current_comments
    comments.where("created_at > ?", DateTime.now.beginning_of_month)
  end

  def current_raffle_entry
    raffle_entries.find_by("created_at > ?", DateTime.now.beginning_of_month)
  end

  def article_raffle_eligible?
    grad? && current_articles.count >= NUM_PUBLICATIONS_FOR_RAFFLE && current_raffle_entry.nil?
  end

  def comment_raffle_eligible?
    undergrad? && current_comments.count >= NUM_PUBLICATIONS_FOR_RAFFLE && current_raffle_entry.nil?
  end

  private

  def add_username
    update!(username: "#{role_name}#{id}")
  end

  def role_name
    case role
    when "undergrad", "control" then "UGRAD"
    when "grad" then "GRAD"
    when "admin" then "PFG"
    end
  end
end
