require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

  def test_should_create_comment
    assert_difference 'Comment.count' do
      comment = create_comment
    end
  end
  
  def test_should_require_name
    assert_no_difference 'Comment.count' do
      comment = create_comment( :name => nil )
      assert ! comment.valid?, comment.to_yaml
    end
  end
  
  def test_should_require_email
    assert_no_difference 'Comment.count' do
      comment = create_comment( :email => nil )
      assert ! comment.valid?, comment.to_yaml
    end
  end
  
  def test_should_require_body
    assert_no_difference 'Comment.count' do
      comment = create_comment( :body => nil )
      assert ! comment.valid?, comment.to_yaml
    end
  end
  
protected

  def create_comment(options={})
    Comment.create({ :commentable => posts(:one), :name => "Pat", :email => "pat@test.com", :body => "Oh yea." }.merge(options))
  end
end
