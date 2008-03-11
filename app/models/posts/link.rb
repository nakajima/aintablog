class Link < Post
  
  validates_presence_of :permalink
  
  def link_text
    header || permalink
  end
  
end