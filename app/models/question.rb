class Question < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  validates_presence_of :author, :text

  def author_name
    author.username
  end

  def paragraphs
    text.split(/[\r\n]+/)
  end
end
