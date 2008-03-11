require File.dirname(__FILE__) + '/../test_helper'

class QuoteTest < ActiveSupport::TestCase
  
  def test_should_create_quote
    assert_difference 'Quote.count' do
      quote = create_quote
    end
  end
  
  def test_should_require_content
    assert_no_difference 'Quote.count' do
      quote = create_quote( :content => nil )
      assert ! quote.valid?, quote.to_yaml
    end
  end

protected
  
  def create_quote(options={})
    Quote.create({ :header => "Some link", :content => "Some URL", :cite => "From here...", :user_id => users(:quentin).id }.merge(options))
  end
  
end