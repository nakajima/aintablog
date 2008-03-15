class Object
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method)
    send method if respond_to? method
  end
end

SITE_SETTINGS = YAML.load_file(File.join(RAILS_ROOT, 'config', 'settings.yml'))