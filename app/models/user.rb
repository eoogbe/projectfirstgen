class User < ActiveRecord::Base
  NUM_PUBLICATIONS_FOR_RAFFLE = 3
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :confirmable, :invitable
  enum school: [:atu, :stanford]
  enum role: [:undergrad, :grad, :control, :admin]
  has_many :articles, foreign_key: :author_id, dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :raffle_entries, dependent: :destroy
  before_create :skip_confirmation_notification!
  after_create :add_username
  validates_presence_of :role, :name
  validates_presence_of :school, unless: :admin?
  validates_uniqueness_of :username

  def self.confirmed
    where.not(confirmed_at: nil)
  end

  def current_articles
    articles.where("created_at > ?", DateTime.now.beginning_of_month)
  end

  def current_comments
    comments.where("created_at > ?", DateTime.now.beginning_of_month)
  end

  def current_questions
    questions.where("created_at > ?", DateTime.now.beginning_of_month)
  end

  def current_raffle_entry
    raffle_entries.find_by("created_at > ?", DateTime.now.beginning_of_month)
  end

  def articles_viewed
    Article
      .joins(:impressions)
      .where(impressions: { user_id: id })
      .order("impressions.created_at DESC")
  end

  def article_raffle_eligible?
    grad? && num_articles_needed_for_raffle <= 0 && current_raffle_entry.nil?
  end

  def comment_raffle_eligible?
    undergrad? && num_comments_needed_for_raffle <= 0 &&
      current_raffle_entry.nil?
  end

  def question_raffle_eligible?
    control? && num_questions_needed_for_raffle <= 0 &&
      current_raffle_entry.nil?
  end

  def num_articles_needed_for_raffle
    NUM_PUBLICATIONS_FOR_RAFFLE - current_articles.count
  end

  def num_comments_needed_for_raffle
    NUM_PUBLICATIONS_FOR_RAFFLE - current_comments.count
  end

  def num_questions_needed_for_raffle
    NUM_PUBLICATIONS_FOR_RAFFLE - current_questions.count
  end

  def article_impression_count
    Impression.where(impressionable: articles).count
  end

  private

  def add_username
    update!(username: "#{role_name}#{id}") if username.nil?
  end

  def role_name
    case role
    when "undergrad", "control" then "UGRAD"
    when "grad" then "GRAD"
    when "admin" then "PFG"
    end
  end
end
