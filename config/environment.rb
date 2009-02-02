# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += %W[
      #{RAILS_ROOT}/app/models/posts
      #{RAILS_ROOT}/app/models/feeds
    ]

  config.action_controller.session = {
    :session_key => '_aintablog_session',
    :secret      => '181d7e70eb790ceff32f283c373e39ca512ff461d86210571efb2ab49e29fe5763a6e4e27f618efbdbe93b4ac3a0a4339cf7033c18f9ddaf2ec845d44fc32bea'
  }

  # These gems are totally required
  config.gem 'feed-normalizer'
  config.gem 'hpricot'
  config.gem 'rubypants'
  config.gem 'RedCloth'
  config.gem 'nokogiri'
end

require 'authenticated_model'

ActionController::Base.cache_store = :file_store, "#{RAILS_ROOT}/public/cache"
