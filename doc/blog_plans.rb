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
  # url:string doctype:string 
end