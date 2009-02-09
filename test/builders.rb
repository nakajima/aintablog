require 'faker'

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
    klass.protected :feed, :user
    klass.new :header => 'A name', :content => 'Some content', :feed => new_feed
  end
  
  define_builder(Feed) do |klass, overrides|
    klass.new(:uri => "file://#{MOCK_ROOT}/daringfireball.xml")
  end
end