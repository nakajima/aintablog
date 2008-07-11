xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{SITE_SETTINGS['site_title']}: #{@post_type.pluralize.titleize}"
    xml.description SITE_SETTINGS['site_tagline']
    xml.link formatted_posts_url(:rss)
    @posts.each do |post|
      xml.item do
        xml.title post.name
        xml.description case post
        when Snippet then "<pre>#{post.content}</pre>"
        when Article then RedCloth.new(post.content).to_html
        else
          post.content
        end
        xml.author post.user.try(:name) || post.feed.try(:title)
        xml.guid post.from_feed? ? post.permalink : url_for(post) rescue url_for(post)
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link feed_url_for(post)
      end
    end
  end
end