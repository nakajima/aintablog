class Article < Post
  
  has_permalink :header
  
  has_many :comments, :as => :commentable
  
  attr_accessible :content, :header

  validates_presence_of :header, :content

end
