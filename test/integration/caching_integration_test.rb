# TODO make this test more consistent.

require "#{File.dirname(__FILE__)}/../test_helper"

class CachingIntegrationTest < ActionController::IntegrationTest
  fixtures :posts, :feeds
  
  def setup
    wipe_cache!
    ActionController::Base.perform_caching = true
  end
  
  def test_should_page_cache_posts_index
    assert_paths_cached('/index.html') do
      get '/'
    end
  end
  
  def test_should_page_cache_articles_index
    assert_paths_cached('/articles.html') do
      get '/articles'
    end
  end
  
  def test_should_page_cache_snippets_index
    assert_paths_cached('/snippets.html') do
      get '/snippets'
    end
  end
  
  # Show Caches
  
  def test_should_page_cache_article_show_page
    article = posts(:article)
    assert_paths_cached("/articles/#{article.permalink}.html") do
      get "/articles/#{article.permalink}"
    end
  end
  
  def test_should_page_cache_snippet_show_page
    snippet = posts(:snippet)
    assert_paths_cached("/snippets/#{snippet.permalink}.html") do
      get "/snippets/#{snippet.permalink}"
    end
  end
  
  def test_should_page_cache_post_page_links
    assert_paths_cached("/posts/page/1.html") do
      get '/posts/page/1'
    end
  end
  
  def test_should_page_cache_articles_page_link
    assert_paths_cached("/articles/page/1.html") do
      get '/articles/page/1'
    end
  end
  
  # Expiration Tests ---------------------------------------------------
  
  def test_should_be_able_to_expire_by_path
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('/index.html', '/posts/', '/articles/', '/articles') do
      @controller.expire_path('/index.html')
      @controller.expire_path('/posts')
      @controller.expire_path('/articles.html')
      @controller.expire_path('/articles')
    end
  end
  
  def test_should_expire_index
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('/index.html', '/posts', '/articles', '/articles.html') do
      @controller.instance_variable_set("@post", posts(:article))
      @controller.send :expire_index!
    end
  end
  
  # Expiring main index
  
  def test_should_expire_home_page_on_post_create
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('index.html', 'posts/', 'articles/', 'articles.html') do
      login_as :quentin
      post '/posts', :post => { :type => 'Article', :header => 'Something', :content => 'Something else' }
    end
  end
  
  def test_should_expire_home_page_on_post_update
    article = posts(:article)
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('index.html', 'posts/', 'articles/', 'articles.html') do
      login_as :quentin
      put "/articles/#{article.permalink}", :article => { :content => 'well this is different' }
      assert_redirected_to post_path(article)
    end
  end
  
  def test_should_expire_home_page_on_post_destroy
    article = posts(:article)
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('index.html', 'posts/', 'articles/', 'articles.html') do
      login_as :quentin
      delete "/articles/#{article.permalink}"
    end
  end
  
  def test_should_expire_home_page_on_single_feed_refresh
    feed = feeds(:blog)
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('index.html', 'posts/', 'articles/', 'articles.html') do
      login_as :quentin
      put feed_path(feed, :refresh => true)
    end
  end
  
  def test_should_expire_home_page_on_all_feeds_refresh
    feed = feeds(:blog)
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1', '/tweets', '/tweets/page/1'
    assert_cache_expired('index.html', 'posts/', 'articles/', 'articles.html', 'tweets/', 'tweets.html') do
      login_as :quentin
      post refresh_feeds_path
    end
  end
  
  def test_should_expire_home_page_on_comment_create
    article = posts(:article)
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('index.html', 'posts/', 'articles/', 'articles.html') do
      post "/articles/#{article.permalink}/comments", :comment => { :name => 'Pat', :email => 'pat@example.com', :body => "Totally." }
    end
  end
  
  def test_should_expire_home_page_on_comment_update
    article = posts(:article)
    comment = comments(:one)
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('index.html', 'posts/', 'articles/', 'articles.html') do
      login_as :quentin
      put comment_path(comment), :comment => { :name => 'Pat!', :email => 'pat@example.com', :body => "Totally." }
    end
  end
  
  def test_should_expire_home_page_on_comment_destroy
    article = posts(:article)
    comment = comments(:one)
    get_paths '/', '/posts/page/1', '/articles', '/articles/page/1'
    assert_cache_expired('index.html', 'posts/', 'articles/', 'articles.html') do
      login_as :quentin
      delete comment_path(comment)
    end
  end
  
  # Expiring show pages
  
  def test_should_expire_show_page_on_update
    article = posts(:article)
    assert_post_expired(article) do
      login_as :quentin
      put article.link, :article => { :content => 'this is new' }
    end
  end
  
  def test_should_expire_show_page_on_comment_create
    article = posts(:article)
    get article.link
    assert_cache_expired("#{article.link}.html") do
      post "#{article.link}/comments", :comment => { :name => 'Pat', :email => 'pat@example.com', :body => "Totally." }
    end
  end
  
  # TODO
  
  def teardown
    wipe_cache!
    ActionController::Base.perform_caching = false
  end

private
  
  def get_paths(*urls)
    urls.each { |url| get url }
  end
  
  def login_as(name)
    post session_path, :email => users(name).email, :password => 'test'
  end
  
  def wipe_cache!
    %w(/index.html /posts.html /posts /articles.html /articles /snippets.html /snippets).each do |file|
      file = RAILS_ROOT + '/public' + file
      FileUtils.rm_rf(file) if File.exists?(file)
    end
  end
  
  def assert_post_cached(resource)
    assert_paths_cached("#{resource.link}.html") { yield }
  end
  
  def assert_post_expired(resource)
    get_paths(resource.link)
    assert_cache_expired("#{resource.link}.html") { yield }
  end
  
  def assert_paths_cached(*urls)
    raise "You must pass a block" unless block_given?
    ActionController::Base.perform_caching = true
    urls.each { |url| assert ! cache_exists_for?(url), "cache should not exist yet. remove public#{url}" }
    yield
    urls.each { |url| assert cache_exists_for?(url), "cache not generated for #{url}" }
  end
  
  def assert_cache_expired(*urls)
    urls.each { |url| assert cache_exists_for?(url), "cache should already exist. missing: public#{url}" }
    block_given? ? yield : urls.each { |url| get url }
    urls.each { |url| assert ! cache_exists_for?(url), "cache not expired for #{url}" }
  end
  
  def cache_exists_for?(file)
    File.exists?(RAILS_ROOT + '/public/' + file)
  end
end