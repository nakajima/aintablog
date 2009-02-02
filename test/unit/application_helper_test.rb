require File.dirname(__FILE__) + '/../test_helper'
require 'nokogiri'

class ApplicationHelperTest < ActiveSupport::TestCase

  include ApplicationHelper

  def test_spanify_links
    assert_equal 1, Nokogiri::HTML(spanify_links("<a href='foo'>single_word</a>")).search("span").size
    assert_equal 1, Nokogiri::HTML(spanify_links("<a href='foo'>two words</a>")).search("span").size
    assert_equal 2, Nokogiri::HTML(spanify_links("<a href='foo'>link one</a> foobar <a href='foo'>link two</a>")).search("span").size
  end

end
