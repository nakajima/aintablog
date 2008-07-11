class Twitter < Feed
  
  entries_become :tweets
  
  def refresh!
    entries.each do |entry|
      tweet = tweets.build :permalink => entry.urls.first, :content => entry.content.gsub(/\A\w*:?\s/, '')
      tweet.created_at = entry.try(:date_published)
      tweet.save ? tweet : tweet.destroy
    end
  end

end