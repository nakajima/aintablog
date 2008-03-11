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
  
protected

  def create_article(options={})
    users(:quentin).articles.create({ :header => 'A Title', :content => 'Some content' }.merge(options))
  end
end
