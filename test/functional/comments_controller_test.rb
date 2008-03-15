require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase

  def test_should_create_comment
    assert_difference('Comment.count') do
      post :create, :comment => { :name => 'Pat', :email => 'pat@example.com', :body => "Totally." }, :article_id => posts(:one).permalink
    end

    assert_redirected_to "#{article_path(posts(:one))}#comments"
  end

  def test_should_destroy_comment
    login_as :quentin
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => comments(:one).id, :article_id => posts(:one).permalink
    end

    assert_redirected_to article_path(posts(:one))
  end
end
