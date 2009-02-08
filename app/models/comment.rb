class Comment < ActiveRecord::Base

  acts_as_defensio_comment :fields => {
    :content => :body,
    :author => :name,
    :author_email =>:email,
    :author_url => :website,
    :article => :commentable
  } if SITE_SETTINGS[:use_defensio]

  belongs_to :commentable, :polymorphic => true

  validates_presence_of :name, :email, :body
  
  named_scope :spammy, :conditions => 'spam = 1'
  named_scope :hammy, :conditions => 'spam = 0'

  def texilized_body
    text = body || ''
    RedCloth.new(text).to_html
  end
end
