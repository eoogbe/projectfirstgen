class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:undergrad, :grad, :control]
  has_many :articles, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id
  validates_presence_of :role, :name
  
  def num_current_articles
    articles.where("created_at > ?", DateTime.now.beginning_of_month).count
  end
  
  def num_current_comments
    comments.where("created_at > ?", DateTime.now.beginning_of_month).count
  end
  
  def username
    @username ||= "#{role_name}#{id}"
  end
  
  private
  
  def role_name
    case role
    when "undergrad", "control" then "UGRAD"
    when "grad" then "GRAD"
    end
  end
end
