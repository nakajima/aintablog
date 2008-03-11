require File.dirname(__FILE__) + '/../test_helper'

class LinkTest < ActiveSupport::TestCase
  
  def test_should_create_link
    assert_difference 'Link.count' do
      link = create_link
    end
  end
  
  def test_should_require_permalink
    assert_no_difference 'Link.count' do
      link = create_link( :permalink => nil )
      assert ! link.valid?, link.to_yaml
    end
  end
  
  def test_link_text_should_fallback_to_permalink
    link = create_link
    assert_equal link.header, link.link_text
    Link.any_instance.expects(:header).returns(nil)
    assert_equal link.permalink, link.link_text
  end

protected
  
  def create_link(options={})
    Link.create({ :header => "Some link", :permalink => "Some URL", :cite => "From here...", :user_id => users(:quentin).id }.merge(options))
  end
  
end