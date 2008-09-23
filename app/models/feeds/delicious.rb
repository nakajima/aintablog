class Delicious < Feed
  
  entries_become :links do |entry|
    link = links.build :permalink => entry.urls.first, :header => entry.title, :content => entry.content
    link.created_at = entry.date_published
    link.save
  end
  
end