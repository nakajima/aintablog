class Github < Feed
  
  entries_become :gists
  
  def refresh!
    entries.each do |entry|
      gist = gists.build :content => entry.content, :header => entry.title
      gist.permalink  = entry.urls.first
      gist.created_at = entry.try(:date_published)
      gist.updated_at = entry.try(:last_updated)
      gist.save
    end
    update_attribute :updated_at, Time.now
  end
  

end
