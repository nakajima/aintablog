# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def spanned_link(*args)
    text = '<span>' + args.shift + '</span>'
    args = args.insert(0, text)
    link_to(*args)
  end
  
  def partial_for(post)
    render :partial => "/posts/types/#{post.type.to_s.downcase}.html.erb", :locals => { :post => post }
  end
  
end
