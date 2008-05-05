module Aintablog
  module ValidMarkupHelper
    def self.included(base)
      base.class_eval do
        def tag_with_open(name, options={}, open=true, escape=true)
          tag_without_open(name, options, true, escape)
        end
        alias_method_chain :tag, :open
      end
    end
  end
end
 
ActionView::Helpers::TagHelper.send :include, Aintablog::ValidMarkupHelper

unless defined?(RAILS_ROOT)
  RAILS_ROOT = File.dirname(__FILE__) + '/../../'
  RAILS_ENV = 'development'
  require 'yaml'
end

class Object
  def try(method, *args, &block)
    respond_to?(method) ? send(method, *args, &block) : nil
  end
end

unless File.file?("#{RAILS_ROOT}/config/settings.yml")
  include FileUtils
  copy_file("#{RAILS_ROOT}/config/settings.yml.sample", "#{RAILS_ROOT}/config/settings.yml")
end

site_settings = YAML.load_file(File.join(RAILS_ROOT, 'config', 'settings.yml'))[RAILS_ENV]
SITE_SETTINGS = HashWithIndifferentAccess.new(site_settings)