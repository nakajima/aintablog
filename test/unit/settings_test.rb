require File.dirname(__FILE__) + '/../test_helper'

class SettingsTest < ActiveSupport::TestCase
  def test_should_load_site_name
    assert_equal 'AintaBlog', SITE_SETTINGS['site_name']
  end
  
  def test_should_load_site_tagline
    assert_equal 'When all else fails, use aintablog on the stain.', SITE_SETTINGS['site_tagline']
  end
end