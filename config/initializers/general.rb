unless defined?(RAILS_ROOT)
  RAILS_ROOT = File.dirname(__FILE__) + '/../../'
  RAILS_ENV = 'development'
  require 'yaml'
end

class Object
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method)
    send method if respond_to? method
  end
end

unless File.file?("#{RAILS_ROOT}/config/settings.yml")
  include FileUtils
  copy_file("#{RAILS_ROOT}/config/settings.yml.sample", "#{RAILS_ROOT}/config/settings.yml")
end

site_settings = YAML.load_file(File.join(RAILS_ROOT, 'config', 'settings.yml'))[RAILS_ENV]
SITE_SETTINGS = HashWithIndifferentAccess.new(site_settings)