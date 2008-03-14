class Article < Post
  
  # We don't want to generate permalinks for imported posts
  has_permalink :header, :if => :user_id
  
  has_many :comments, :as => :commentable

  validates_presence_of :header, :content
  validates_uniqueness_of :permalink
  
  attr_accessible :content, :header, :permalink
  
  def allow_comments?
    !! user_id
  end
  
  def from_feed?
    !! feed_id
  end
  
  def link(root='')
    from_feed? ? permalink : "#{root}/posts/#{permalink}"
  end
end
