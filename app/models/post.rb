class Post < ActiveRecord::Base
  named_scope :active, :conditions => 'deleted_at IS NULL'

  belongs_to :user
  belongs_to :feed
  
  has_many :comments, :as => :commentable, :conditions => ['comments.spam = ?', false]

  validates_uniqueness_of :permalink, :scope => :type
  validates_presence_of :user_id, :unless => :feed_id
  validates_presence_of :feed_id, :unless => :user_id
  
  class << self
    def paginate_index(options={})
      active.paginate({:order => 'posts.created_at DESC', :include => [:comments, :feed]}.merge(options))
    end
  end
  
  def self.per_page; 10; end

  def name
    header
  end
  
  def from_feed?
    !!feed_id && (feed_id != 0)
  end
  
  def type
    attributes['type']
  end
  
  def to_param
    permalink
  end
  
  def delete!
    update_attribute :deleted_at, Time.now
  end
  
  def deleted?
    !!deleted_at
  end
  
  def link(root='')
    "#{root}/#{type.tableize}/#{to_param}"
  end
end
