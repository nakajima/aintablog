class Flickr < Feed
  
  entries_become :pictures do |picture, entry|
    picture.cite = entry.urls.first
    picture.header = entry.title
    picture.permalink = (Hpricot(entry.content)/"img").first['src'].gsub(/_m/, '')
    picture.created_at = entry.try(:date_published)
    picture.updated_at = entry.try(:last_updated)
    picture.save
  end
  
end