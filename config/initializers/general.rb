require 'feed-normalizer'
require 'hpricot'
require 'will_paginate_hacks.rb'
require 'markup_helper.rb'
require 'core-ext/kernel.rb'
require 'core-ext/object.rb'
require 'core-ext/string.rb'

unless defined?(RAILS_ROOT)
  RAILS_ROOT = File.dirname(__FILE__) + '/../../'
  RAILS_ENV = 'development'
  require 'yaml'
end

unless File.file?("#{RAILS_ROOT}/config/settings.yml")
  include FileUtils
  copy_file("#{RAILS_ROOT}/config/settings.yml.sample", "#{RAILS_ROOT}/config/settings.yml")
end

site_settings = YAML.load_file(File.join(RAILS_ROOT, 'config', 'settings.yml'))[RAILS_ENV]
SITE_SETTINGS = HashWithIndifferentAccess.new(site_settings)

