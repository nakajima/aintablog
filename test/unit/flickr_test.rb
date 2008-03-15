require File.dirname(__FILE__) + '/../test_helper'

class FlickrTest < ActiveSupport::TestCase

  def test_should_create_flickr
    assert_difference 'Flickr.count' do
      flickr = create_flickr
    end
  end
  
  def test_should_parse_flickr_feed
    flickr = create_flickr
    assert_equal 7, flickr.entries.length
  end
  
  def test_should_create_pictures
    flickr = create_flickr
    assert_difference 'Picture.count', 7 do
      flickr.refresh!
    end
  end
  
  def test_should_not_create_pictures_twice
    flickr = create_flickr
    flickr.refresh!
    assert_no_difference 'Picture.count' do
      flickr.refresh!
    end
  end

protected

  def create_flickr(options={})
    Flickr.create({ :uri => "file://#{MOCK_ROOT}/flickr_feed.xml" }.merge(options))
  end
end