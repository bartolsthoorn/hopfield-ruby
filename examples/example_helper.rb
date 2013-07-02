# Include C extension
puts 'Building C extension'

Dir.chdir('ext/hopfield') do
  output = `ruby extconf.rb`
  raise output unless $? == 0
  output = `make`
  raise output unless $? == 0
end

# Enables require 'hopfield/hopfield' in Ruby
$: << File.dirname(__FILE__) + '/../ext'