module Pancake
  # Pancake file
  class FlapJackFile
    def self.record_type(record_klass)
      @record_klass = record_klass
    end

    def self.record_class
      @record_klass
    end

    attr_reader :records

    def initialize(blob = nil)
      @records = []

      if blob
        load(blob)
      end
    end

    def load(blob)
      lines = blob.split("\n")

      lines.each do |line|
        record = self.class.record_class.new
        record.load(line)

        @records << record
      end
    end

    def dump
      @records.map {|r| r.dump }.join("\n")
    end
  end
end
