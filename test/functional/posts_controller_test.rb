require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase
  
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
end
