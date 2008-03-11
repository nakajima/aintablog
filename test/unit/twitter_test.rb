require File.dirname(__FILE__) + '/../test_helper'

class TwitterTest < ActiveSupport::TestCase

  def test_should_create_twitter
    assert_difference 'Twitter.count' do
      twitter = create_twitter
    end
  end
  
  def test_should_parse_twitter_feed
    twitter = create_twitter :uri => "#{MOCK_ROOT}/twitter_feed.xml"
    assert_equal 20, twitter.entries.length
  end
  
  def test_should_create_posts
    assert_difference 'Post.count', 20 do
      twitter = create_twitter :uri => "file://#{MOCK_ROOT}/twitter_feed.xml"
      twitter.create_posts!
    end
  end

  def test_should_not_create_posts_twice
    twitter = create_twitter :uri => "file://#{MOCK_ROOT}/twitter_feed.xml"
    twitter.create_posts!
    assert_no_difference 'Post.count' do
      twitter.create_posts!
    end
  end

protected

  def create_twitter(options={})
    Twitter.create({ :uri => "http://twitter.com/public_timeline.xml" }.merge(options))
  end
end