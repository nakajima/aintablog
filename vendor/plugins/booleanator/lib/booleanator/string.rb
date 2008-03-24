module Nakajima
  module Booleanator
    module StringHelper
      # Converts a string to either true or false based, using values greater
      # than 1 as true, and others as false. It also converts the string 'true'
      # into a true boolean.
      def to_boolean
        !!( (to_i > 0) || match(/true/i) || (length == 1 ? match(/t/) : false) )
      end
    end
  end
end

String.send(:include, Nakajima::Booleanator::StringHelper)

