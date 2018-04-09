require_relative "../field"

module Pancake
  module FieldTypes
    class Text < Field
      def load(data)
        if field_params[:strip]
          data.strip
        else
          data
        end
      end

      def dump(value)
        value = handle_newlines(value)

        if @length
          value = value.to_s[0...length]
        end

        super(value)
      end

      private

      def handle_newlines(data)
        if field_params[:preserve_newlines]
          data
        else
          data.gsub(/\n+/, ' ')
        end
      end
    end
  end
end
