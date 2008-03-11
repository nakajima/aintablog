class Post < ActiveRecord::Base
  validates_presence_of :user_id, :permalink
  
  def to_param
    permalink
  end
end
