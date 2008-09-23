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
          class_inheritable_accessor :entry_type # What do entries become 
          include(InstanceMethods)
          extend(ClassMethods)
        end
      end      
    end
    
    module ClassMethods
      def entries_become(post_type, &block)
        self.entry_type = post_type
        has_many post_type.to_sym, :foreign_key => :feed_id, :dependent => :destroy
        define_method(:refresh!) do
          logger.debug "=> creating #{post_type} from #{uri}"
          entries.each(&block.bind(self))
          self.updated_at = Time.now
          self.save
        end
      end
    end
    
    module InstanceMethods
      # Yields to the URI or file
      def with_indifferent_io
        begin
          oi = uri.match(/file:/) ? File.open(uri.gsub(%r{^file://}, '')) : open(uri)
          yield oi
        ensure
          oi.close if oi
        end
      end
      
      def fetch_feed
        with_indifferent_io do |io|
          FeedNormalizer::FeedNormalizer.parse(io)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Aintablog::Feedable