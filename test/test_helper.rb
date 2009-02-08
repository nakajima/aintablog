MOCK_ROOT = File.dirname(__FILE__) + '/mocks' unless defined?(MOCK_ROOT)
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'
require 'fixjour'
require File.join(File.dirname(__FILE__), *%w[builders])
begin
  require 'redgreen'
rescue LoadError
  
end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :all

  include Fixjour
  include AuthenticatedTestHelper

  #
  #  for testing when aintablog is hosted under a relative url,
  #  e.g., "http://my.domain.com/aintablog/"
  #
  def set_relative_url &block
    old = nil
    new = "/relative"
    if ActionController::Base.respond_to?('relative_url_root=')
      old = ActionController::Base.relative_url_root
      ActionController::Base.relative_url_root = new
    else
      old = ActionController::AbstractRequest.relative_url_root
      ActionController::AbstractRequest.relative_url_root = new
    end
    begin
      block.call
    ensure
      if ActionController::Base.respond_to?('relative_url_root=')
        ActionController::Base.relative_url_root = old
      else
        ActionController::AbstractRequest.relative_url_root = old
      end
    end
  end

end
