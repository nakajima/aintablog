require 'digest/sha1'
class User < ActiveRecord::Base
  authenticated_model
  
  attr_accessible :name
  
  validates_presence_of :name, :message => "can't be blank"  
    
end
