class Flickr < Feed
  entries_become :pictures
  
  def refresh!
    entries.each do |entry|
      doc = Hpricot(entry.content)
      picture = pictures.build \
        :permalink => (doc/"img").first['src'].gsub(/_m/, ''),
        :header => entry.title,
        :cite => entry.urls.first
      # picture.created_at = entry.try(:date_published)
      picture.updated_at = entry.try(:last_updated)
      picture.save
    end
    update_attribute :updated_at, Time.now
  end
end