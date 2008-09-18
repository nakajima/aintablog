class Github < Feed
  
  entries_become :gists
=begin
  def refresh!
    entries.each do |entry|
      p entry
      tweet = tweets.build :permalink => entry.urls.first, :content => entry.content.gsub(/\A\w*:?\s/, '')
      tweet.created_at = entry.try(:date_published)
      tweet.save ? tweet : tweet.destroy
    end
  end
=end  
  
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