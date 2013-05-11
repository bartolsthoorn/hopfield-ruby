module Hopfield
  
  # Two learning rules have been implemented, storkey and hebbian
  # See: http://en.wikipedia.org/wiki/Hopfield_network#Learning_Rules
  HEBBIAN_RULE = 1
  STORKEY_RULE = 2
  
  class Training
    attr_accessor :patterns, :neurons, :weights, :pattern_dimensions,  :rule
    
    def initialize(patterns, rule=Hopfield::HEBBIAN_RULE)
      # Check if patterns are the same size
      unless patterns.map(&:size).uniq.count == 1
        raise ArgumentError, 'Inconsistent pattern size'
      end
      
      # Calculate the amount of required neurons
      # This number is based on the number of inputs of a pattern
      net_size =  patterns.first.map(&:size).inject{|sum,x| sum + x }
      
      self.pattern_dimensions = Hash.new
      self.pattern_dimensions[:width] =  patterns.first.first.size
      self.pattern_dimensions[:height] = patterns.first.size
      
      # Flatten patterns to 1D array
      self.patterns = patterns.map { |pattern| pattern.flatten }
      
      # Turn 0 into -1
      self.patterns = self.patterns.map { |pattern| pattern.map { |value| (value == 0 ? -1 : value) }}
      
      # Create neurons
      self.neurons = Array.new(self.patterns.first.length) { Neuron.new }
      
      self.weights = Array.new
      
      # Train the neurons
      train(rule)
    end
    
    def set_weight(neuron_index, other_neuron_index, weight)
      # Connections are symmetric, so ij is the same as ji, so store it only once
      ij = [neuron_index, other_neuron_index].sort
      self.weights[ij.first] = [] if self.weights[ij.first].nil?
      self.weights[ij.first][ij.last] = weight
    end
    
    def train(rule)
      # Neurons are fully connected; every neuron has a weight value for every other neuron
      case rule
        when Hopfield::HEBBIAN_RULE
          self.neurons.count.times do |i|
            for j in ((i+1)...self.neurons.count) do
              next if i == j
              weight = 0.0
              self.patterns.each do |pattern|
                weight += pattern[i] * pattern[j]
              end
              set_weight(i, j, weight / self.patterns.count)
            end
          end
        when Hopfield::STORKEY_RULE
          
        else
          abort 'Unknown learning rule specified, either use Hopfield::STORKEY_RULE or Hopfield::HEBBIAN_RULE'
        end
    end
    
  end
end