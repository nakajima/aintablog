module Nakajima
  module Booleanator
    module IntegerHelper
      def to_boolean
        !!(self > 0)
      end
    end
  end
end

Integer.send(:include, Nakajima::Booleanator::IntegerHelper)