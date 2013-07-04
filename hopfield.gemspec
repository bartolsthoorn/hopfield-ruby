# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
Gem::Specification.new do |s|
  s.name        = "hopfield"
  s.version     = "1.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bart Olsthoorn"]
  s.email       = ["bartolsthoorn@gmail.com"]
  s.homepage    = "http://github.com/bartolsthoorn/hopfield-ruby"
  s.summary     = "Ruby implementation of a Hopfield Network"
  s.description = "Hopfield networks can be used for smart pattern recollections. It's recalling patterns by modelling associative memory of a neural network"
  s.license     = "MIT"
 
  s.add_development_dependency "rspec"
  s.add_development_dependency "chunky_png"
 
  s.files        = Dir.glob("lib/**/*") + Dir.glob('ext/**/*.{c,h,rb}') + %w(LICENSE README.md)
  s.extensions = ['ext/hopfield/extconf.rb']
  
  s.require_path = 'lib'
end