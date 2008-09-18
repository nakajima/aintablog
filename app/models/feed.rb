class Feed < ActiveRecord::Base
  
  acts_as_feed
  
  has_many :posts
  
  validates_presence_of :uri
  validates_format_of :uri, :with => %r{^(http|file)://}i, :on => :create
  
  after_create :learn_attributes!
  
  class << self
    def refresh_all!
      find(:all).each(&:refresh!)
    end
    
    def types
      # Loading all of the subclasses so we can have a list of the various types.
      Dir["#{RAILS_ROOT}/app/models/feeds/*.rb"].each { |f| require_dependency f }
      
      self.subclasses.collect(&:to_s)
    end
  end
  
  def refresh=(res)
    refresh! if res.to_boolean
    return true
  end
  
  def learn_attributes!
    self.title  = fetched_feed.title
    self.description = fetched_feed.description
    self.url = fetched_feed.urls.first
    self.update_timestamp
    self.save
  end
  
  def type
    attributes['type']
  end
  
  def update_timestamp
    self.last_updated_at = fetched_feed.last_updated || fetched_feed.entries.sort_by(&:date_published).last.date_published
  end
  
  def entries
    @entries ||= fetch_feed.entries
  end
  
  def fetched_feed
    @fetched_feed ||= fetch_feed
  end
  
end
