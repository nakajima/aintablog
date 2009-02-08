require 'faker'

Fixjour::MergingProxy.class_eval do
  def unprotect(*attrs)
    old = @klass.accessible_attributes || []
    @klass.attr_accessible *(attrs.to_a + old.to_a)
    result = yield
    @klass.attr_accessible *old.to_a
    result
  end
end

Fixjour :verify => true do
  define_builder(User) do |klass, overrides|
    klass.new \
      :name => 'quire',
      :email => Faker::Internet.email,
      :password => 'quire',
      :password_confirmation => 'quire'
  end
  
  define_builder(Post) do |klass, overrides|
    klass.new \
      :feed => new_feed,
      :header => Faker::Lorem.sentence,
      :content => 'Some content'
  end
  
  define_builder(Article) do |klass, overrides|
    klass.unprotect(:feed, :user, :source) do
      klass.new :header => 'A name', :content => 'Some content', :feed => new_feed
    end
  end
  
  define_builder(Feed) do |klass, overrides|
    klass.new(:uri => "file://#{MOCK_ROOT}/daringfireball.xml")
  end
end