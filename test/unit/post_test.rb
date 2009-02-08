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
  
  def test_should_override_to_param_as_permalink_for_non_feeds
    post = create_post :feed_id => nil
    assert_equal post.permalink, post.to_param
  end
  
  def test_should_override_to_param_as_id_for_feeds
    post = create_post :feed_id => 1
    assert_equal post.id.to_s, post.to_param
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

    assert post = create_post(:content => content, :format => 'RedCloth')
    assert h = Hpricot.parse(post.to_html)
    assert_equal 1, h.search('h1').size
    assert_equal 2, h.search('p').size
  end

protected

  def create_post(options={})
    Post.create({ :header => 'A name', :content => 'Some content', :user_id => users(:quentin).id, :feed_id => feeds(:one).id, :permalink => 'ok' }.merge(options))
  end
end
