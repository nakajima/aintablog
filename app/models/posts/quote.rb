class Quote < Post
  
  has_permalink :content
  
  validates_presence_of :content
  
end