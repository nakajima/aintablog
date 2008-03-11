class Quote < Post
  
  has_many :comments, :as => :commentable
  
  has_permalink :content
  
  validates_presence_of :content
  
end