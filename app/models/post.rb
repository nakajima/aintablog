class Post < ActiveRecord::Base
  named_scope :active, :conditions => 'deleted_at IS NULL'

  belongs_to :user
  belongs_to :feed
  
  has_many :comments, :as => :commentable, :conditions => ['comments.spam = ?', false]

  validates_uniqueness_of :permalink, :scope => :type
  validates_presence_of :user_id, :unless => :feed_id
  validates_presence_of :feed_id, :unless => :user_id
  
  before_save :mark_uncommentable, :if => :from_feed?
  
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
    self[:type]
  end
  
  def to_param
    from_feed? ? id.to_s : permalink
  end
  
  def delete!
    update_attribute :deleted_at, Time.now
  end
  
  def deleted?
    !!deleted_at
  end
  
  def link(root='')
    relative_url = ActionController::Base.respond_to?('relative_url_root=') ? ActionController::Base.relative_url_root : ActionController::AbstractRequest.relative_url_root
    "#{relative_url}#{root}/#{type.tableize}/#{to_param}"
  end

  def to_html
    text = case format
    when 'HTML' then content
    else RedCloth.new(content, [:filter_styles, :no_span_caps]).to_html
    end
  end
  
  private
  
  def mark_uncommentable
    self.allow_comments = false
    self # otherwise this returns false and we can't save
  end

end
