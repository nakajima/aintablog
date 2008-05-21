class Snippet < Post
  
  has_many :comments, :as => :commentable
  
  has_permalink :name
  
  validates_presence_of :content, :lang
  
  def name
    header.blank? ? "#{SyntaxFu::TYPES.index(lang).downcase}-snippet" : header
  end
  
end