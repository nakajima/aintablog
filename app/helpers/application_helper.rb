# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def spanned_link(*args)
    text = '<span>' + args.shift + '</span>'
    args = args.insert(0, text)
    link_to(*args)
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
  
end
