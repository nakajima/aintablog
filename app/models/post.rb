class Post < ActiveRecord::Base
  validates_presence_of :user_id, :permalink
  
  def self.per_page; 5; end
  
  def type
    attributes['type']
  end
  
  def to_param
    permalink
  end
end
