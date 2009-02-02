class Github < Feed
  
  entries_become :gists do |gist, entry|
    gist.content = entry.content
    gist.header = entry.title
    gist.permalink  = entry.urls.first
    gist.created_at = entry.try(:date_published)
    gist.updated_at = entry.try(:last_updated)
    gist.save
  end

end

