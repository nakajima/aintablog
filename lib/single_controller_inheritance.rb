module SingleControllerInheritance
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def expose_as(*types, &block)
      options = types.extract_options!
      namespace = options[:namespace]
      
      types.each do |child|
        class_name = namespace.to_s + child.to_s.titleize + 'Controller'
        controller = Class.new(self) do
          block[child] if block_given?
        end
      
        logger.info "=> Generating new %s subclass: %s" % [child, class_name]
      
        scope = namespace ? namespace.constantize : Object
        scope.const_set(class_name, controller)
      end
    end
  end
end