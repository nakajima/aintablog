require File.dirname(__FILE__) + '/../test_helper'

class FeedTest < ActiveSupport::TestCase

  def test_should_create_feed
    assert_difference 'Feed.count' do
      create_feed
    end
  end
  
  def test_should_require_uri
    assert_no_difference 'Feed.count' do
      feed = create_feed( :uri => nil )
    end
  end
  
  def test_should_require_valid_uri
    assert_no_difference 'Feed.count' do
      feed = create_feed( :uri => 'well this cant work' )
    end
  end
  
  def test_should_learn_attributes
    feed = create_feed :uri => "file://#{MOCK_ROOT}/daringfireball.xml"
    feed.learn_attributes!
    assert_equal 'Daring Fireball', feed.title
    assert_equal Time.parse('Tue Mar 11 21:06:03 UTC 2008'), feed.last_updated_at
    assert_equal 'Mac and web curmudgeonry/nerdery. By John Gruber.', feed.description
  end

  def test_should_have_entries
    feed = create_feed :uri => "file://#{MOCK_ROOT}/daringfireball.xml"
    assert_not_nil feed.entries
    assert ! feed.entries.empty?
  end

protected

  def create_feed(options={})
    Feed.create({ :uri => "file://#{MOCK_ROOT}/daringfireball.xml" }.merge(options))
  end
  
end
