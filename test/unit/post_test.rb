require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase
  
  def test_should_create_post
    assert_difference 'Post.count' do
      create_post
    end
  end
  
  def test_should_require_source
    post = new_post(:user => nil, :feed => nil)
    assert ! post.valid?
    assert_not_nil post.errors.on(:source)
  end
  
  def test_should_create_with_only_user
    assert new_post(:user => new_user).valid?
  end
  
  def test_should_create_with_only_feed_id
    assert new_post(:feed => new_feed).valid?
  end
  
  def test_should_override_to_param_as_permalink_for_non_feeds
    post = create_post :feed => nil, :user => new_user
    assert_equal post.permalink, post.to_param
  end
  
  def test_should_override_to_param_as_id_for_feeds
    post = create_post :feed => new_feed
    assert_equal post.id.to_s, post.to_param
  end
  
  def test_not_allow_comments_if_from_feed
    post = create_post :feed => new_feed
    assert ! post.allow_comments?
  end

  def test_should_be_deleted_not_destroyed
    post = posts(:one)
    assert ! post.deleted?
    assert_no_difference 'Post.count' do
      post.delete!
    end
    assert post.deleted?
  end
  
  def test_format_html
    content = <<-EOF
<h1>line break trouble?</h1>
this is a <a href='#'>problem
that I found</a> or is it
really a problem?
    EOF
    assert post = create_post(:content => content, :format => 'HTML')
    assert h = Hpricot.parse(post.to_html)
    assert_equal 0, h.search('br').size # when we try to redclothify html, this fails.
  end

  def test_format_redcloth
    content = <<-EOF
h1. redcloth

this is a redcloth document.

really a problem?
    EOF
    assert post = create_post(:content => content)
    assert h = Hpricot.parse(post.to_html)
    assert_equal 1, h.search('h1').size
    assert_equal 2, h.search('p').size

    assert post = create_article(:content => content, :format => 'RedCloth')
    assert h = Hpricot.parse(post.to_html)
    assert_equal 1, h.search('h1').size
    assert_equal 2, h.search('p').size
  end
end
