class Comment < ActiveRecord::Base

  acts_as_defensio_comment :fields => { :content => :body, :author => :name, :author_email => :email, :author_url => :website, :article => :commentable }

  belongs_to :commentable, :polymorphic => true

  validates_presence_of :name, :email, :body

  def texilized_body
    text = body || ''
    RedCloth.new(text).to_html
  end
end
