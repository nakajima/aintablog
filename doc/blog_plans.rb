class Post < ActiveRecord::Base
  # Attributes:
  # permalink:string header:string content:text cite:string type:string user_id:id lang:string comment_counter:integer
end

class Article < Post  
end

class Tweet < Post  
end

class Snippet < Post  
end

class Picture < Post  
end

class Quote < Post  
end

class Link < Post  
end

# -------------------------------

class Feed < ActiveRecord::Base
  # Attributes:
  # last_updated_at:datetime title:string url:string description:text uri:string user_id:integer type:string
  
  def self.inherited(subclass)
    subclass.send :include, Aintablog::Feedable
  end
  
  def poll!
    
  end
  
end

class Twitter < Feed
  entries_become :tweets
end

class Blog < Feed
  entries_become :articles
end

class Flickr < Feed
  entries_become :pictures
end

