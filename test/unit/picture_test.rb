require File.dirname(__FILE__) + '/../test_helper'

class PictureTest < ActiveSupport::TestCase

  def test_should_create_picture
    assert_difference 'Picture.count' do
      picture = create_picture
    end
  end
  
protected
  
  def create_picture(options={})
    users(:quentin).pictures.create({ :permalink => 'http://some_image_url.com' }.merge(options))
  end
  
end