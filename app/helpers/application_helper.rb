# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def spanned_link(*args)
    text = '<span>' + args.shift + '</span>'
    args = args.insert(0, text)
    link_to(*args)
  end
  
  def spanify_links(text)
    text.gsub(/<a\s(.*)>(.*)<\/a>/ix) do |s|
      "<a #{$1}><span>#{strip_tags($2)}</span></a>"
    end
  end
  
  def partial_for(post)
    render :partial => "/posts/types/#{post.type.downcase}.html.erb", :locals => { :post => post }
  end
  
  def comments_link_for(post)
    text = (post.comments.length < 1) ? 'No comments' : pluralize(post.comments.length, 'comment')
    path = send("#{post.type.downcase}_path", post)
    link_to text, "#{path}#comments"
  end
  
  def twitterize(string)
    string.gsub(/@(\w*)/, '<a href="http://twitter.com/\1"><span>\1</span></a>')
  end
  
  def clean_content_for(post)
    text = post.content
    text.gsub!(/<(script|noscript|object|embed|style|frameset|frame|iframe)[>\s\S]*<\/\1>/, '') if post.from_feed?
    text = RedCloth.new(text, [:filter_styles, :no_span_caps]).to_html
    text = spanify_links(text)
  end
  
end
