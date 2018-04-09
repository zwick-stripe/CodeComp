module Pancake
  class Field
    attr_accessor :name
    attr_accessor :length
    attr_accessor :field_params

    attr_reader :record_name

    def initialize(name, record_name, field_params = {})
      @name = name
      @record_name = record_name
      @length = field_params[:length]
      @field_params = field_params
    end

    def load(data)
      data
    end

    def dump(value)
      @field_params[:max_length] ? value.to_s[0...(@field_params[:max_length])] : value.to_s
    end

    def optional?
      @field_params[:optional] == true
    end
  end
end
