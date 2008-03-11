class Snippet < Post
  
  has_permalink :header
  
  validates_presence_of :header, :content, :lang
  
end