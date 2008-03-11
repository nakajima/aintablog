class Feed < ActiveRecord::Base
  
  acts_as_feed
  
  validates_presence_of :uri
  validates_format_of :uri, :with => %r{^(http|file)://}i, :on => :create
  
  def learn_attributes!
    self.title  = fetched_feed.title
    self.description = fetched_feed.description
    self.update_timestamp
    self.save
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
