class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true

  validates_presence_of :name, :email, :body

  def texilized_body
    text = body || ''
    RedCloth.new(text).to_html
  end
end
