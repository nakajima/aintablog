class Article < Post
  
  has_permalink :header

  validates_presence_of :header, :content

end
