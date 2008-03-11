class Snippet < Post
  
  has_many :comments, :as => :commentable
  
  has_permalink :header
  
  validates_presence_of :header, :content, :lang
  
end