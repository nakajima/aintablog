class Snippet < Post
  
  validates_presence_of :lang
  validates_presence_of :content
  
end