require 'hopfield/hopfield'

require_relative 'hopfield/training'
require_relative 'hopfield/network'

module Hopfield
  # Hopfield consists of two parts:
  # => Training (hopfield/training.rb)
  # => Network  (hopfield/network.rb)
  
  USE_C_EXTENSION = true
end