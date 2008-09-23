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