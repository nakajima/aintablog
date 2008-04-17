require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase
  
  def test_should_create_post
    assert_difference 'Post.count' do
      post = create_post
    end
  end
  
  def test_should_require_user_id_sans_feed_id
    assert_no_difference 'Post.count' do
      post = create_post({ :user_id => nil, :feed_id => nil })
    end
  end
  
  def test_should_create_with_only_user_id
    assert_difference 'Post.count' do
      post = create_post( :feed_id => nil )
    end
  end
  
  def test_should_create_with_only_feed_id
    assert_difference 'Post.count' do
      post = create_post( :user_id => nil )
    end
  end
  
  def test_should_override_to_param
    post = create_post
    assert_equal post.permalink, post.to_param
  end

  def test_should_be_deleted_not_destroyed
    post = posts(:one)
    assert ! post.deleted?
    assert_no_difference 'Post.count' do
      post.delete!
    end
    assert post.deleted?
  end
  
protected

  def create_post(options={})
    Post.create({ :header => 'A name', :content => 'Some content', :user_id => users(:quentin).id, :feed_id => feeds(:one).id, :permalink => 'ok' }.merge(options))
  end
end
