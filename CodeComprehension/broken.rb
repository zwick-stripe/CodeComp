require_relative 'pancake'

class ExampleRecord < Pancake::FlapJackRecord
  column_separator '|'
  column_count 4

  add_field Pancake::FieldTypes::Text, 'merchant', {}
  add_field Pancake::FieldTypes::Text, 'charge', {}
  add_field Pancake::FieldTypes::Number, 'amount', {}
  add_field Pancake::FieldTypes::Text, 'descriptor', {}
end

class ExampleFile < Pancake::FlapJackFile
  record_type ExampleRecord
end

contents = File.read('broken.txt')

file = ExampleFile.new(contents)

file.records.each_with_index do |record, idx|
  puts "line #{idx}"
  puts record.dump

end

puts "And the whole file...\n"
puts file.dump
