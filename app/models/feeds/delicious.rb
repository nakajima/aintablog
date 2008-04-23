class Delicious < Feed
  
  has_many :links, :foreign_key => :feed_id, :dependent => :destroy
  
  def refresh!
    entries.each do |entry|
      logger.debug '=> adding entry'
      link = links.build :permalink => entry.urls.first, :header => entry.title, :cite => entry.content
      link.created_at = entry.date_published
      link.save
    end
  end
  
end