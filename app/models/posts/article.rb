class Article < Post
  acts_as_defensio_article :fields => { :author => :source, :title => :header } if SITE_SETTINGS[:use_defensio]
  
  # We don't want to generate permalinks for imported posts
  has_permalink :header, :unless => :from_feed?

  validates_presence_of :header, :content
  validates_uniqueness_of :permalink
  
  attr_accessible :content, :header, :permalink, :allow_comments
  
  def link(root='')
    from_feed? ? permalink : super
  end
  
  def author_email
    source.try(:email) || SITE_SETTINGS['user_email']
  end
  
  def name
    header
  end
  
  def to_param
    from_feed? ? id.to_s : permalink
  end
end
