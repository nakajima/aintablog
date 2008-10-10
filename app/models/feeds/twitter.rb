class Twitter < Feed
  
  entries_become :tweets do |tweet, entry|
    tweet.content = entry.content.gsub(/\A\w*:?\s/, '')
    tweet.permalink = entry.urls.first
    tweet.created_at = entry.try(:date_published)
    tweet.save ? tweet : tweet.destroy
  end

end