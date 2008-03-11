require 'digest/sha1'
class User < ActiveRecord::Base
  authenticated_model
  
  has_many :articles
  has_many :quotes
  has_many :snippets
  has_many :links
  
  attr_accessible :name
  
  validates_presence_of :name, :message => "can't be blank"  
    
end
