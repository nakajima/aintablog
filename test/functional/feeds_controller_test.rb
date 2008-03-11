require File.dirname(__FILE__) + '/../test_helper'

class FeedsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_feed
    assert_difference('Feed.count') do
      post :create, :feed => { :uri => 'http://daringfireball.net/feed.xml' }
    end

    assert_redirected_to feed_path(assigns(:feed))
  end

  def test_should_show_feed
    get :show, :id => feeds(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => feeds(:one).id
    assert_response :success
  end

  def test_should_update_feed
    put :update, :id => feeds(:one).id, :feed => { }
    assert_redirected_to feed_path(assigns(:feed))
  end

  def test_should_destroy_feed
    assert_difference('Feed.count', -1) do
      delete :destroy, :id => feeds(:one).id
    end

    assert_redirected_to feeds_path
  end
end
