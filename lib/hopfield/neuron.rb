module Hopfield
  class Neuron
    attr_accessor :weights, :output
    
    def initialize(pattern_size)
      minmax = Array.new(pattern_size) { [-0.5, 0.5] }
      
      self.weights =  random_vector(minmax)
    end
    
    def random_vector(minmax)
      return Array.new(minmax.size) do |i|
        minmax[i][0] + ((minmax[i][1] - minmax[i][0]) * rand())
      end
    end
    
  end
end