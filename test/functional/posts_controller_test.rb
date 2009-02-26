require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase
  
  # Generated tests
  
  test "should_get_index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end
  
  test "should provide etag for index" do
    get :index
    assert_not_nil @response.etag
  end
  
  test "should provide last_modified for index" do
    @newest = create_article
    get :index
    assert_equal @newest.updated_at.to_s, @response.last_modified.to_s
  end
  
  test "should_get_show" do
    get :show, :id => posts(:one).permalink
    assert_response :success
  end
  
  test "should provide etag for show" do
    get :show, :id => posts(:one).permalink
    assert_not_nil @response.etag
  end
  
  test "should_redirect_to_admin_index_if_logged_in" do
    login_as :quentin
    get :index
    assert_redirected_to admin_posts_path
  end

  test "should_redirect_to_admin_index_if_logged_in_even_for_relative_urls" do
    set_relative_url do
      login_as :quentin
      get :index
      assert_redirected_to admin_posts_path
    end
  end
  
  test "should_redirect_to_admin_show_if_logged_in" do
    login_as :quentin
    get :show, :id => posts(:one).permalink
    assert_redirected_to admin_post_path(posts(:one))
  end

  test "should_redirect_to_admin_show_if_logged_in_even_for_relative_urls" do
    set_relative_url do
      login_as :quentin
      get :show, :id => posts(:one).permalink
      assert_redirected_to admin_post_path(posts(:one))
    end
  end
  
  # # Post types
  #
  # NOTE Since these are all now handled by dynamically created controllers,
  #      we'll need a different way of testing them.
  # 
  # test "should_retrieve_links_only" do
  #   @request.stubs(:path).returns('/links')
  #   Link.expects(:paginate_index).returns(posts_stub)
  #   Post.expects(:paginate_index).never
  #   get :index
  #   assert_response :success
  #   assert_equal 'links', assigns(:post_type)
  # end
  # 
  # test "should_retrieve_articles_only" do
  #   @request.stubs(:path).returns('/articles')
  #   Article.expects(:paginate_index).returns(posts_stub)
  #   Post.expects(:paginate_index).never
  #   get :index
  #   assert_response :success
  #   assert_equal 'articles', assigns(:post_type)
  # end
  # 
  # test "should_retrieve_snippets_only" do
  #   @request.stubs(:path).returns('/snippets')
  #   Snippet.expects(:paginate_index).returns(posts_stub)
  #   Post.expects(:paginate_index).never
  #   get :index
  #   assert_response :success
  #   assert_equal 'snippets', assigns(:post_type)
  # end
  # 
  # test "should_retrieve_tweets_only" do
  #   @request.stubs(:path).returns('/tweets')
  #   Tweet.expects(:paginate_index).returns(posts_stub)
  #   Post.expects(:paginate_index).never
  #   get :index
  #   assert_response :success
  #   assert_equal 'tweets', assigns(:post_type)
  # end
  # 
  # test "should_retrieve_quotes_only" do
  #   @request.stubs(:path).returns('/quotes')
  #   Quote.expects(:paginate_index).returns(posts_stub)
  #   Post.expects(:paginate_index).never
  #   get :index
  #   assert_response :success
  #   assert_equal 'quotes', assigns(:post_type)
  # end
  # 
  # test "should_retrieve_pictures_only" do
  #   @request.stubs(:path).returns('/pictures')
  #   Picture.expects(:paginate_index).returns(posts_stub)
  #   Post.expects(:paginate_index).never
  #   get :index
  #   assert_response :success
  #   assert_equal 'pictures', assigns(:post_type)
  # end

  test "should_show_post" do
    get :show, :id => posts(:one).permalink
    assert_response :success
  end
  
  test "should_redirect_to_index_from_show_unless_article" do
    get :show, :id => posts(:two).id
    assert_redirected_to root_path
  end

  test "should_redirect_to_index_from_show_unless_article_even_for_relative_urls" do
    set_relative_url do
      get :show, :id => posts(:two).id
      assert_redirected_to root_path
    end
  end
  
  test "feed_tag" do
    get :index
    assert(h = Hpricot.parse(@response.body))
    links = h.search("link[@type='application/rss+xml']")
    assert_equal 4, links.size
    links.each do |j|
      assert_match %r{^http://test.host/[^/]+.rss$}, j['href']
    end
  end

  test "feed_tag_with_relative_urls" do
    set_relative_url do
      get :index
      assert(h = Hpricot.parse(@response.body))
      links = h.search("link[@type='application/rss+xml']")
      assert_equal 4, links.size
      links.each do |j|
        assert_match %r{^http://test.host/relative/[^/]+.rss$}, j['href']
      end
    end
  end

  private
  
  def posts_stub
    Post.paginate_index(:page => 1)
  end
end
