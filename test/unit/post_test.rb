require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase
  
  def test_should_create_post
    assert_difference 'Post.count' do
      post = create_post
    end
  end
  
  def test_should_require_user_id
    assert_no_difference 'Post.count' do
      post = create_post( :user_id => nil )
      assert ! post.valid?, post.to_yaml
    end
  end
  
protected

  def create_post(options={})
    Post.create({ :header => 'A name', :content => 'Some content', :type => 'Article', :user_id => users(:quentin).id, :permalink => 'ok' }.merge(options))
  end
end
