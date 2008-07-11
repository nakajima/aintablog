require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase
  
  # controller_class.perform_caching = false
  def setup
    ActionController::Base.perform_caching = false
  end
  
  # Custom tests
  
  def test_should_create_article
    login_as :quentin
    assert_difference('Post.count') do
      post :create, :post => { :type => 'Article', :header => 'Something', :content => 'Something else' }
    end

    assert_redirected_to posts_path
  end
  
  def test_should_create_snippet
    login_as :quentin
    assert_difference('Post.count') do
      post :create, :post => { :type => 'Snippet', :header => 'Something', :content => 'Something else', :lang => 'Ruby' }
    end

    assert_redirected_to posts_path
  end
  
  # Generated tests
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
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

  def test_should_get_new
    login_as :quentin
    get :new
    assert_response :success
  end

  def test_should_create_post
    login_as :quentin
    assert_difference('Post.count') do
      post :create, :post => { :type => 'Article', :header => 'Something', :content => 'Something else' }
      assert assigns(:post)
      assert_redirected_to posts_path
    end
  end
  
  def test_should_mark_as_uncommentable
    login_as :quentin
    post :create, :post => { :type => 'Article', :header => 'Something', :content => 'Something else', :allow_comments => '0' }
    assert assigns(:post), "Didn't assign post"
    assert ! assigns(:post).allow_comments?, "Allowed comments"
  end

  def test_should_show_post
    get :show, :id => posts(:one).permalink
    assert_response :success
  end
  
  def test_should_redirect_to_index_from_show_unless_article
    get :show, :id => posts(:two).id
    assert_redirected_to '/'
  end

  def test_should_get_edit
    login_as :quentin
    get :edit, :id => posts(:one).permalink
    assert_response :success
  end

  def test_should_update_post
    login_as :quentin
    put :update, :id => posts(:one).permalink, :post => { }
    assert_redirected_to post_path(assigns(:post))
  end

  def test_should_delete_post
    login_as :quentin
    post = posts(:one)
    assert ! post.deleted?
    assert_no_difference('Post.count') do
      delete :destroy, :id => post.to_param
    end
    assert post.reload.deleted?
    assert_redirected_to posts_path
  end
  
  def test_should_delete_imported_post
    login_as :quentin
    post = posts(:imported_article)
    assert post.from_feed?
    assert_no_difference('Post.count') do
      delete :destroy, :id => post.to_param
    end
    assert post.reload.deleted?
    assert_redirected_to posts_path
  end
  
  private
  
  def posts_stub
    Post.paginate_index(:page => 1)
  end
end
