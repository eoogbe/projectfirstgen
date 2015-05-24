class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:undergrad, :grad, :control]
  has_many :articles, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id
  validates_presence_of :username, :role
  validates_uniqueness_of :username, case_sensitive: false
  attr_accessor :login
  
  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash)
        .find_by("LOWER(username) = :login OR LOWER(email) = :login", login: login.downcase)
    else
      find_by(conditions.to_hash)
    end
  end
  
  def num_current_articles
    articles.where("created_at > ?", DateTime.now.month).count
  end
  
  def num_current_comments
    comments.where("created_at > ?", DateTime.now.month).count
  end
end
