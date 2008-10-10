# Overriding will_paginate's url_for method
class WillPaginate::LinkRenderer
  # Returns URL params for +page_link_or_span+, taking the current GET params
  # and <tt>:params</tt> option into account.
  def url_for(page)
    unless @url_string
      # url = @template.url_for(@url_params)
      url = "/#{@options[:posts_type] || 'posts'}/page/#{page}"
      
      # page links should preserve GET parameters
      url.append_params!(@options[:params]) if @template.request.get? && @options[:params]
      
      @url_string = url.sub(%r!([?&/]#{CGI.escape param_name}[=/])#{page}!, '\1@')
      return url
    end
    @url_string.sub '@', page.to_s
  end
  
  private
  
  def stringified_merge(target, other)
    other.each do |key, value|
      key = key.to_s
      existing = target[key]

      if value.is_a?(Hash)
        target[key] = existing = {} if existing.nil?
        if existing.is_a?(Hash)
          stringified_merge(existing, value)
          return
        end
      end
      
      target[key] = value
    end
  end
  
end