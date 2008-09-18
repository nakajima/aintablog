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
      article = articles.build :content => entry.content, :header => entry.title
      article.permalink  = entry.urls.first
      article.created_at = entry.try(:date_published)
      article.updated_at = entry.try(:last_updated)
      article.save
    end
    update_attribute :updated_at, Time.now
  end
  

end