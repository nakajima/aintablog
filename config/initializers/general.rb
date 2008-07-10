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

# Move this to plugin
class String
  def query_params
    params = Hash.new([].freeze)
    query_string = self.match(/\?(.*)/).try :[], 1
    
    return { } if query_string.blank?
    
    query_string.to_s.split(/[&;]/n).each do |pairs|
      key, value = pairs.split('=',2).collect{|v| CGI::unescape(v) }
      if params.has_key?(key)
        params[key].push(value)
      else
        params[key] = [value]
      end
    end
    params
  end
  
  def append_params(new_params={})
    split = self.split(/\?/)
    old_params = self.query_params
    new_params.each { |key, value| old_params[key] = value }
    str_params = old_params.inject([]) do |memo, pair|
      memo << pair.join('=')
      memo
    end.join('&')
    res = split[0]
    res += ('?' + str_params) unless str_params.blank?
    res
  end
  
  def append_params!(new_params={})
    res = append_params(new_params)
    gsub!(self, res)
  end
end

unless File.file?("#{RAILS_ROOT}/config/settings.yml")
  include FileUtils
  copy_file("#{RAILS_ROOT}/config/settings.yml.sample", "#{RAILS_ROOT}/config/settings.yml")
end

site_settings = YAML.load_file(File.join(RAILS_ROOT, 'config', 'settings.yml'))[RAILS_ENV]
SITE_SETTINGS = HashWithIndifferentAccess.new(site_settings)

# Overriding will_paginate's url_for method
class WillPaginate::LinkRenderer
  # Returns URL params for +page_link_or_span+, taking the current GET params
  # and <tt>:params</tt> option into account.
  def url_for(page)
    unless @url_string
      # url = @template.url_for(@url_params)
      url = "/#{@options[:posts_type] || 'posts'}/page/#{page}"
      
      # page links should preserve GET parameters
      url.append_params!(@options[:params]) if @template.request.get? && @options[:params]
      
      @url_string = url.sub(%r!([?&/]#{CGI.escape param_name}[=/])#{page}!, '\1@')
      return url
    end
    @url_string.sub '@', page.to_s
  end
  
  private
  
  def stringified_merge(target, other)
    other.each do |key, value|
      key = key.to_s
      existing = target[key]

      if value.is_a?(Hash)
        target[key] = existing = {} if existing.nil?
        if existing.is_a?(Hash)
          stringified_merge(existing, value)
          return
        end
      end
      
      target[key] = value
    end
  end
  
end