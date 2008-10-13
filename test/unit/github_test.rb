require File.dirname(__FILE__) + '/../test_helper'

class GithubTest < ActiveSupport::TestCase

  FEED_URI = "file://#{MOCK_ROOT}/github_feed.xml"

  def test_should_create_github
    assert_difference 'Gist.count' do
      github = create_github
    end
  end
  
  def test_should_parse_github_feed
    github = create_github :uri => FEED_URI
    assert_equal 10, github.entries.length
  end
  
  def test_should_create_github
  
    # only loads this month's changes.
    assert_difference 'Gist.count', 2 do
      twitter = create_github :uri => FEED_URI
      twitter.refresh!
    end
  end

  def test_should_not_create_posts_twice
    github = create_github :uri => FEED_URI
    github.refresh!
    assert_no_difference 'Gist.count' do
      github.refresh!
    end
  end

protected

  def create_github(options={})
    Github.create({ :uri => FEED_URI }.merge(options))
  end
end
