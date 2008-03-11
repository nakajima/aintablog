class Post < ActiveRecord::Base
  attr_accessible :header, :content, :cite, :type
end
