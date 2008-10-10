class Blog < Feed
  
  entries_become :articles do |article, entry|
    article.header = entry.title
    article.content = entry.content
    article.permalink  = entry.urls.first
    article.created_at = entry.try(:date_published)
    article.updated_at = entry.try(:last_updated)
    article.save
  end

end