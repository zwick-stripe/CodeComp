module Pancake
  class FlapJackRecord
    include FieldTypes
    # DSL methods
    def self.column_separator(column_separator)
      @column_separator = column_separator if column_separator && column_separator.is_a?(String)
    end

    def self.get_column_separator; @column_separator; end

    def self.column_count(column_count)
      @column_count = column_count if column_count && column_count.is_a?(Integer)
    end

    def self.get_column_count; @column_count; end

    ##### End of DSL methods #####

    def self.list_field_names
      @fields.keys
    end

    def self.field_definitions
      @fields
    end

    def field_definitions
      self.class.field_definitions
    end

    def self.has_field_definition?(expected_name)
      field_definitions.any? {|name,_| name == expected_name }
    end

    def self.get_field(key)
      @fields[key][1] if @fields
    end

    def self.field_values
      list_field_names.map { |name| get_field(name) }
    end

    def self.add_field(type, name, flags)
      field = type.new(name, name, flags)

      add_field_details(field, name)
    end

    def self.add_field_details(field, name)
      @fields ||= []
      @fields << [name, field]
    end

    #
    # Internals/instance methods
    #

    def [](field_name)
      if self.class.has_field_definition?(field_name)
        @field_values[field_name]
      else
        raise ArgumentError, "Please add field details before trying to access its value."
      end
    end

    def []=(field_name, value)
      if self.class.has_field_definition?(field_name)
        @field_values[field_name] = value
      else
        raise ArgumentError, "Please add field details before trying to access its value."
      end
    end

    def record_name
      self.class.record_name
    end

    def initialize
      @column_separator = self.class.get_column_separator
      @column_count = self.class.get_column_count
      @field_values = {}
    end

    def load_field(chunk, field_index)
      data = chunk.gsub(/\A\s+/, '').gsub(/\s+\z/, '') == '' ? nil : chunk

      field_name, field_definition = field_definitions[field_index]

      @field_values[field_name] = field_definition.load(data)
    end

    def load(line)
      data = line.split(@column_separator)

      if data.length == @column_count
        data.each_with_index do |chunk, idx|
           load_field(chunk, idx)
        end
      else
        raise ArgumentError, "Unable to find the correct number of fields (#{@column_count}). Found #{data.length} instead."
      end
    end

    def dump_field(field)
      value = self.send(field.name)
      chunk = field.dump(value[1])
    end

    def dump_all_fields
      if fields
        self.list_field_names.map do |field_name|
          self.dump_field(field_name)
        end
      end
    end

    def dump
      data = ''

      field_definitions.each_with_index do |(name,field_definition),col|
        val = field_definition.dump(self[name])

        data << val

        unless col == @column_count - 1
          data << @column_separator
        end
      end

      data
    end

    def to_h
      @field_values
    end
  end
end
