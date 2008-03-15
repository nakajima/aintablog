require 'feed-normalizer'
require 'hpricot'

module Aintablog
  module Feedable
    def self.included(base)
      base.extend(ActMethods)
    end
    
    module ActMethods
      def acts_as_feed
        unless included_modules.include? InstanceMethods 
          class_inheritable_accessor :target_class # What do entries become 
          extend(ClassMethods)
          include(InstanceMethods)
        end
      end      
    end
    
    module InstanceMethods
      # Yields to the URI or file
      def with_indifferent_io(&block)
        begin
          f = uri.match(/file:/) ? File.open(uri.gsub(%r{^file://}, '')) : open(uri)
          return yield(f)
        ensure
          f.close if f
        end
      end
      
      def fetch_feed
        with_indifferent_io do |io|
          FeedNormalizer::FeedNormalizer.parse(io)
        end
      end
    end
    
    module ClassMethods
      def entries_become(target)
        self.target_class = target.to_s.classify.constantize
      end
    end
  end
end

ActiveRecord::Base.send :include, Aintablog::Feedable