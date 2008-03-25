module Nakajima
  module Booleanator
    module NilHelper
      def to_boolean
        return false
      end
    end
  end
end

NilClass.send :include, Nakajima::Booleanator::NilHelper