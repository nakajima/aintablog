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

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
      assert_redirected_to root_path
    end
  end

  def test_should_allow_signup_when_relative_url
    set_relative_url do
      assert_difference 'User.count' do
        create_user
        assert_response :redirect
        assert_redirected_to root_path
      end
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end
  

  protected
    def create_user(options = {})
      post :create, :user => { :email => 'quire@example.com', :name => 'quire',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
