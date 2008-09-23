class Blog < Feed
  
  entries_become :articles do |entry|
    article = articles.build :content => entry.content, :header => entry.title
    article.permalink  = entry.urls.first
    article.created_at = entry.try(:date_published)
    article.updated_at = entry.try(:last_updated)
    article.save
  end

end