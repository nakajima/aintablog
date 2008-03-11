class Article < Post
  
  has_permalink :header
  
  attr_accessible :content, :header

  validates_presence_of :header, :content

end
