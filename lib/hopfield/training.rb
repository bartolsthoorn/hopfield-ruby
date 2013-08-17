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
      
      @pattern_dimensions = Hash.new
      @pattern_dimensions[:width] =  patterns.first.first.size
      @pattern_dimensions[:height] = patterns.first.size
      
      # Flatten patterns to 1D array
      @patterns = patterns.map { |pattern| pattern.flatten }
      
      # Turn 0 into -1
      @patterns = @patterns.map { |pattern| pattern.map { |value| (value == 0 ? -1 : value) }}
      
      # Create neurons
      @neurons = Array.new(@patterns.first.length) { 0.0 }
      
      @weights = Array.new
      
      # Train the neurons
      train(rule)
    end
    
    def set_weight(neuron_index, other_neuron_index, weight)
      # Connections are symmetric, so ij is the same as ji, so store it only once
      ij = [neuron_index, other_neuron_index].sort
      @weights[ij.first] = [] if @weights[ij.first].nil?
      @weights[ij.first][ij.last] = weight
    end
    
    def train(rule)
      # Neurons are fully connected; every neuron has a weight value for every other neuron
      case rule
        when Hopfield::HEBBIAN_RULE
          if USE_C_EXTENSION
            @weights = Hopfield::calculate_weights_hebbian(@patterns, @neurons.count)
          else
            # Ruby equivalent of the calculate_weights_hebbian C function
            @neurons.count.times do |i|
              for j in ((i+1)...@neurons.count) do
                next if i == j
                weight = 0.0
                @patterns.each do |pattern|
                  weight += pattern[i] * pattern[j]
                end
                set_weight(i, j, weight / @patterns.count)
              end
            end
          end
        when Hopfield::STORKEY_RULE
          # Still has to be implemented in both Ruby and C
        else
          abort 'Unknown learning rule specified, either use Hopfield::STORKEY_RULE or Hopfield::HEBBIAN_RULE'
        end
    end
    
  end
end