class Delicious < Feed
  
  entries_become :links do |link, entry|
    link.header = entry.title
    link.content = entry.content
    link.permalink = entry.urls.first
    link.created_at = entry.date_published
    link.save
  end
  
end