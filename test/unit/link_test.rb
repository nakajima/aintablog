require File.dirname(__FILE__) + '/../test_helper'

class LinkTest < ActiveSupport::TestCase
  
  def test_should_create_link
    assert_difference 'Link.count' do
      link = create_link
    end
  end
  
  def test_should_require_content
    assert_no_difference 'Link.count' do
      link = create_link( :content => nil )
      assert ! link.valid?, link.to_yaml
    end
  end

protected
  
  def create_link(options={})
    Link.create({ :header => "Some link", :content => "Some URL", :cite => "From here...", :user_id => users(:quentin).id }.merge(options))
  end
  
end