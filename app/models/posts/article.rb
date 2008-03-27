class Article < Post
  acts_as_defensio_article
  
  # We don't want to generate permalinks for imported posts
  has_permalink :header, :if => :user_id
  
  has_many :comments, :as => :commentable

  validates_presence_of :header, :content
  validates_uniqueness_of :permalink
  
  attr_accessible :content, :header, :permalink, :allow_comments
  
  def allow_comments=(status)
    self.feed_id = (status == '0') ? 0 : nil
  end
  
  def allow_comments?
    feed_id.nil?
  end
  
  def from_feed?
    !!feed_id && (feed_id != 0)
  end
  
  def link(root='')
    from_feed? ? permalink : "#{root}/posts/#{permalink}"
  end
end
