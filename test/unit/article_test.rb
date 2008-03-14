require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase

  def test_should_create_an_article
    assert_difference 'Article.count' do
      article = create_article
    end
  end
  
  def test_should_require_header
    assert_no_difference 'Article.count' do
      article = create_article( :header => nil )
      assert ! article.valid?, article.to_yaml
    end
  end
  
  def test_should_require_content
    assert_no_difference 'Article.count' do
      article = create_article( :content => nil )
      assert ! article.valid?, article.to_yaml
    end
  end
  
  def test_should_generate_permalink
    article = create_article
    assert_not_nil article.permalink
  end
  
  def test_should_have_allow_comments_boolean_helper
    article = create_article
    assert article.allow_comments?
    article.user_id = nil
    article.feed_id = feeds(:one).id
    assert ! article.allow_comments?
  end
  
  def test_should_have_from_feed_boolean_helper
    article = create_article
    assert ! article.from_feed?
    article.user_id = nil
    article.feed_id = feeds(:one).id
    assert article.from_feed?
  end
  
  def test_should_strip_style_from_imported_articles
    article = feeds(:blog).articles.create \
      :header => 'Something',
      :content => "You know...<style>\n  .bad { color: white }\n</style>",
      :permalink => 'http://daringfirebal.net/something.html'
    assert ! article.content.match(/<style>/), "Didn't remove style open tag"
    assert ! article.content.match(/\.bad \{ color\: white \}/), "Didn't remove rogue styles"
    assert ! article.content.match(/<\/style>/), "Didn't remove style close tag"
    assert_equal 'You know...', article.content
  end
  
protected

  def create_article(options={})
    users(:quentin).articles.create({ :header => 'A Title', :content => 'Some content' }.merge(options))
  end
end
