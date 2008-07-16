require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase
  
  # Generated tests
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end
  
  def test_should_get_show
    get :show, :id => posts(:one).permalink
    assert_response :success
  end
  
  def test_should_redirect_to_admin_index_if_logged_in
    login_as :quentin
    get :index
    assert_redirected_to admin_posts_path
  end
  
  def test_should_redirect_to_admin_show_if_logged_in
    login_as :quentin
    get :show, :id => posts(:one).permalink
    assert_redirected_to admin_post_path(posts(:one))
  end
  
  # Post types
  
  def test_should_retrieve_links_only
    @request.expects(:path).returns('/links')
    Link.expects(:paginate_index).returns(posts_stub)
    Post.expects(:paginate_index).never
    get :index
    assert_response :success
    assert_equal 'links', assigns(:post_type)
  end
  
  def test_should_retrieve_articles_only
    @request.expects(:path).returns('/articles')
    Article.expects(:paginate_index).returns(posts_stub)
    Post.expects(:paginate_index).never
    get :index
    assert_response :success
    assert_equal 'articles', assigns(:post_type)
  end
  
  def test_should_retrieve_snippets_only
    @request.expects(:path).returns('/snippets')
    Snippet.expects(:paginate_index).returns(posts_stub)
    Post.expects(:paginate_index).never
    get :index
    assert_response :success
    assert_equal 'snippets', assigns(:post_type)
  end
  
  def test_should_retrieve_tweets_only
    @request.expects(:path).returns('/tweets')
    Tweet.expects(:paginate_index).returns(posts_stub)
    Post.expects(:paginate_index).never
    get :index
    assert_response :success
    assert_equal 'tweets', assigns(:post_type)
  end
  
  def test_should_retrieve_quotes_only
    @request.expects(:path).returns('/quotes')
    Quote.expects(:paginate_index).returns(posts_stub)
    Post.expects(:paginate_index).never
    get :index
    assert_response :success
    assert_equal 'quotes', assigns(:post_type)
  end
  
  def test_should_retrieve_pictures_only
    @request.expects(:path).returns('/pictures')
    Picture.expects(:paginate_index).returns(posts_stub)
    Post.expects(:paginate_index).never
    get :index
    assert_response :success
    assert_equal 'pictures', assigns(:post_type)
  end

  def test_should_show_post
    get :show, :id => posts(:one).permalink
    assert_response :success
  end
  
  def test_should_redirect_to_index_from_show_unless_article
    get :show, :id => posts(:two).id
    assert_redirected_to '/'
  end
  
  private
  
  def posts_stub
    Post.paginate_index(:page => 1)
  end
end
