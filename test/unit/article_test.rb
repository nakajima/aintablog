require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase

  def test_should_create_an_article
    assert_difference 'Article.count' do
      article = create_article
    end
  end
  
  def test_should_require_header
    article = new_article(:header => nil)
    assert ! article.valid?
    assert_not_nil article.errors.on(:header)
  end
  
  def test_should_require_content
    article = new_article(:content => nil)
    assert ! article.valid?
    assert_not_nil article.errors.on(:content)
  end
  
  def test_should_generate_permalink
    article = new_article(:source => new_user)
    assert article.valid?
    assert_not_nil article.permalink
  end
  
  def test_should_provide_proper_link
    article = posts(:article).becomes(Article)
    assert_equal "/articles/#{article.permalink}", article.link
  end

  def test_should_provide_proper_link_even_for_relative_urls
    set_relative_url do
      article = posts(:article).becomes(Article)
      assert_equal "/relative/articles/#{article.permalink}", article.link
    end
  end
end
