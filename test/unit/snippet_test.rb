require File.dirname(__FILE__) + '/../test_helper'

class SnippetTest < ActiveSupport::TestCase
  
  def test_should_create_a_snippet
    assert_difference 'Snippet.count' do
      snippet = create_snippet
    end
  end
  
  def test_should_require_lang
    assert_no_difference 'Snippet.count' do
      snippet = create_snippet( :lang => nil )
      assert ! snippet.valid?, snippet.to_yaml
    end
  end
  
  def test_should_require_content
    assert_no_difference 'Snippet.count' do
      snippet = create_snippet( :content => nil )
      assert ! snippet.valid?, snippet.to_yaml
    end
  end
  
protected

  def create_snippet(options={})
    Snippet.create({ :header => 'A Title', :content => 'Some content', :user_id => users(:quentin).id, :lang => 'Ruby' }.merge(options))
  end
end
