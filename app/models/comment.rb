class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true

  validates_presence_of :name, :email, :body

end
