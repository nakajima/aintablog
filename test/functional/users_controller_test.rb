require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_should_get_new
    User.expects(:count).returns(0)
    get :new
    assert_response :success
  end
  
  def test_should_not_get_new_if_users_exist
    get :new
    assert_redirected_to root_path
  end

  def test_should_not_get_new_if_users_exist_even_for_relative_url
    set_relative_url do
      get :new
      assert_redirected_to root_path
    end
  end
  
  def do_post
    post :create, :user => { :name => 'q', :email => 'q@e.edu', :password => 'hello', :password_confirmation => 'hello' }
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      do_post
      assert_redirected_to root_path
    end
  end

  def test_should_allow_signup_when_relative_url
    set_relative_url do
      assert_difference 'User.count' do
        do_post
        assert_redirected_to root_path
      end
    end
  end
end
