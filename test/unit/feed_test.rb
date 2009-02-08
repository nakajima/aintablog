require File.dirname(__FILE__) + '/../test_helper'

class FeedTest < ActiveSupport::TestCase

  def test_should_create_feed
    assert_difference 'Feed.count' do
      create_feed
    end
  end
  
  def test_should_require_uri
    feed = new_feed(:uri => nil)
    assert ! feed.valid?
    assert_not_nil feed.errors.on(:uri)
  end
  
  def test_should_require_valid_uri
    feed = new_feed(:uri => 'bliggety')
    assert ! feed.valid?
    assert_not_nil feed.errors.on(:uri)
  end
  
  def test_should_learn_title
    feed = create_feed
    teach_feed(feed)
    assert_equal 'Daring Fireball', feed.title
  end
  
  def test_should_learn_last_updated_at
    feed = create_feed
    teach_feed(feed)
    assert_equal Time.parse('Tue Mar 11 21:06:03 UTC 2008'), feed.last_updated_at
  end
  
  def test_should_learn_description
    feed = create_feed
    teach_feed(feed)
    assert_equal 'Mac and web curmudgeonry/nerdery. By John Gruber.', feed.description
  end
  
  def test_should_learn_url
    feed = create_feed
    teach_feed(feed)
    assert_equal 'http://daringfireball.net/', feed.url
  end

  def test_should_have_entries
    feed = create_feed :uri => "file://#{MOCK_ROOT}/daringfireball.xml"
    assert_not_nil feed.entries
    assert ! feed.entries.empty?
  end

protected
  
  def teach_feed(feed)
    feed.learn_attributes!
  end
  
end
