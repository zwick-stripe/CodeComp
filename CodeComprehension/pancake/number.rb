require_relative '../field'

module Pancake
  module FieldTypes
    class Number < Field
      def load(data)
        data.to_i
      end

      def dump(value)
        value ||= @flags[:default]

        if @length.nil?
          data = value.to_s
        else
          data = "%0#{@length}d" % value
        end

        data
      end
    end
  end
end
