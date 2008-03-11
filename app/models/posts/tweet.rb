class Tweet < Post
  
  validates_presence_of :content
  validates_uniqueness_of :permalink
  
end