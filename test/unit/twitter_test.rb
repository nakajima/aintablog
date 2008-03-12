require File.dirname(__FILE__) + '/../test_helper'

class TwitterTest < ActiveSupport::TestCase

  def test_should_create_twitter
    assert_difference 'Twitter.count' do
      twitter = create_twitter
    end
  end
  
  def test_should_parse_twitter_feed
    twitter = create_twitter :uri => "file://#{MOCK_ROOT}/twitter_feed.xml"
    assert_equal 20, twitter.entries.length
  end
  
  def test_should_create_tweets
    assert_difference 'Tweet.count', 20 do
      twitter = create_twitter :uri => "file://#{MOCK_ROOT}/twitter_feed.xml"
      twitter.refresh!
    end
  end

  def test_should_not_create_posts_twice
    twitter = create_twitter :uri => "file://#{MOCK_ROOT}/twitter_feed.xml"
    twitter.refresh!
    assert_no_difference 'Tweet.count' do
      twitter.refresh!
    end
  end

protected

  def create_twitter(options={})
    Twitter.create({ :uri => "file://#{MOCK_ROOT}/twitter_feed.xml" }.merge(options))
  end
end