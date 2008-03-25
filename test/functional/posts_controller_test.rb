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

  def test_should_destroy_post
    login_as :quentin
    assert_difference('Post.count', -1) do
      delete :destroy, :id => posts(:one).permalink
    end

    assert_redirected_to posts_path
  end
end
