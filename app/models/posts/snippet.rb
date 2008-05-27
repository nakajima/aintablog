class Snippet < Post
  acts_as_defensio_article :fields => { :author => :source, :title => :header } if SITE_SETTINGS[:use_defensio]
  
  has_many :comments, :as => :commentable
  
  has_permalink :name
  
  validates_presence_of :content, :lang
  
  def name
    header.blank? ? "#{SyntaxFu::TYPES.index(lang).downcase}-snippet" : header
  end
  
end