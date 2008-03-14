class Post < ActiveRecord::Base

  belongs_to :user
  belongs_to :feed
  
  has_many :comments, :as => :commentable

  validates_uniqueness_of :permalink, :scope => :type
  validates_presence_of :user_id, :unless => :feed_id
  validates_presence_of :feed_id, :unless => :user_id
  
  def self.per_page; 10; end
  
  def type
    attributes['type']
  end
  
  def to_param
    permalink
  end
end
