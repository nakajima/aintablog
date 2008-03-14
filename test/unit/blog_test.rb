require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase

  def test_should_create_blog
    assert_difference 'Blog.count' do
      blog = create_blog
    end
  end
  
  def test_should_parse_blog_feed
    blog = create_blog
    assert_equal 9, blog.entries.length
  end
  
  def test_should_create_articles
    assert_difference 'Article.count', 9 do
      blog = create_blog
      blog.refresh!
    end
  end

  def test_should_not_create_posts_twice
    blog = create_blog
    blog.refresh!
    assert_no_difference 'Article.count' do
      blog.refresh!
    end
  end

protected

  def create_blog(options={})
    Blog.create({ :uri => "file://#{MOCK_ROOT}/dhh.rss" }.merge(options))
  end
end