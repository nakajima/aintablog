class Comment < ActiveRecord::Base

  acts_as_defensio_comment :fields => { :content => :body, :author => :name, :author_email => :email, :author_url => :website, :article => :commentable }

  belongs_to :commentable, :polymorphic => true

  validates_presence_of :name, :email, :body
  
  before_save :report_status
  
  def report_status
    method = spam? ? :report_as_spam : :report_as_ham
    send(method)
  end

  def texilized_body
    text = body || ''
    RedCloth.new(text).to_html
  end
end
