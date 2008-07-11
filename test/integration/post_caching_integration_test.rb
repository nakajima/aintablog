require "#{File.dirname(__FILE__)}/../test_helper"

ActionController::Base.perform_caching = true

class PostCachingIntegrationTest < ActionController::IntegrationTest
  fixtures :posts
  
  def setup
    wipe_cache!
  end
  
  def test_should_page_cache_posts_index
    assert_paths_cached('/index') do
      get '/'
    end
  end
  
  def test_should_page_cache_articles_index
    assert_paths_cached('/articles')
  end
  
  def test_should_page_cache_snippets_index
    assert_paths_cached('/snippets')
  end
  
  # Show Caches
  
  def test_should_page_cache_article_show_page
    article = posts(:article)
    assert_paths_cached("/articles/#{article.permalink}")
  end
  
  def test_should_page_cache_snippet_show_page
    snippet = posts(:snippet)
    assert_paths_cached("/snippets/#{snippet.permalink}")
  end
  
  def test_should_page_cache_post_page_links
    assert_paths_cached("/posts/page/1")
  end
  
  def test_should_page_cache_articles_page_link
    assert_paths_cached("/articles/page/1")
  end
  
  # Expiration Tests ---------------------------------------------------
  
  def test_should_be_able_to_expire_by_path
    get '/'
    get '/posts/page/1'
    get '/articles'
    get '/articles/page/1'
    assert_cache_files_deleted('/index', '/posts/', '/articles/', '/articles') do
      @controller.expire_path('/index.html')
      @controller.expire_path('/posts')
      @controller.expire_path('/articles.html')
      @controller.expire_path('/articles')
    end
  end
  
  def test_should_expire_index
    get '/'
    get '/posts/page/1'
    get '/articles'
    get '/articles/page/1'
    assert_cache_expired('/index.html', '/posts', '/articles', '/articles.html') do
      @controller.instance_variable_set("@post", posts(:article))
      @controller.send :expire_index!
    end
  end
  
  # Expiring main index
  
  def test_should_expire_home_page_on_post_create
    login_as :quentin
    post '/posts', :post => { :type => 'Article', :header => 'Something', :content => 'Something else' }
  end
  
  def test_should_expire_home_page_on_post_update
    article = posts(:article)
    login_as :quentin
    put "/articles/#{article.permalink}", :article => { :content => 'well this is different' }
    assert_redirected_to post_path(article)
  end
  
  def test_should_expire_home_page_on_post_destroy
    article = posts(:article)
    login_as :quentin
    delete "/articles/#{article.permalink}"
  end
  
  def teardown
    wipe_cache!
  end

  private
  
  def login_as(name)
    post session_path, :email => users(name).email, :password => 'test'
  end
  
  def assert_paths_cached(*urls)
    urls.each { |url| assert ! cache_exists_for?(url), "cache should not exist yet. remove public#{url}.html" }
    block_given? ? yield : urls.each { |url| get url }
    urls.each { |url| assert cache_exists_for?(url), "cache not generated for #{url}" }
  end
  
  def assert_cache_files_deleted(*urls)
    urls.each { |url| assert cache_exists_for?(url), "cache should already exist. missing: public#{url}.html" }
    block_given? ? yield : urls.each { |url| get url }
    urls.each { |url| assert ! cache_exists_for?(url), "cache not expired for #{url}" }
  end
  
  def assert_cache_expired(*urls)
    urls.each { |url| FileUtils.expects(:rm_rf).with(RAILS_ROOT + '/public' + url) }
    yield
  end
  
  def cache_exists_for?(file)
    File.exists?(RAILS_ROOT + '/public' + (file.match(/\/$/) ? (file[0..(file.length - 2)]) : "#{file}.html"))
  end
  
  def wipe_cache!
    %w(/index.html /posts.html /posts /articles.html /articles /snippets.html /snippets).each do |file|
      file = RAILS_ROOT + '/public' + file
      FileUtils.rm_rf(file) if File.exists?(file)
    end
  end
end