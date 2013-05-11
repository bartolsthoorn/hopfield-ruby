module Hopfield
  class Network
    attr_accessor :neurons, :patterns, :weights, :state, :pattern_dimensions, :last_error, :runs
    
    def initialize(training, perturbed_pattern)
      unless training.class.to_s == 'Hopfield::Training'
        raise TypeError, 'Training has to be an instance of Hopfield::Training'
      end
      
      unless training.patterns.first.size == perturbed_pattern.flatten.size
        raise SyntaxError, 'Given pattern does not match size of the training patterns'
      end
      
      # Turn 0 into -1
      perturbed_pattern = perturbed_pattern.flatten.map { |value| (value == 0 ? -1 : value) }
      
      self.neurons =  training.neurons
      self.patterns = training.patterns
      self.weights =  training.weights
      self.pattern_dimensions = training.pattern_dimensions
      
      self.neurons.count.times do |i|
        self.neurons[i].state = perturbed_pattern[i]
      end
      
      self.last_error = [1]
      self.runs =       0
    end
    
    def associated?
      return self.last_error.include? 0
    end
    
    def pattern
      return self.state
    end
    
    def get_weight(i , j)
      ij = [i, j].sort
      return self.weights[ij.first][ij.last]
    end
    
    def propagate
      # Select random neuron
      i = rand(self.neurons.count)
      
      activation = 0.0
      
      self.neurons.each_with_index do |other, j|
        next if i == j
        activation += get_weight(i, j)*other.state
      end
      
      output = transfer(activation)
      change = output != self.neurons[i].state
      self.neurons[i].state = output
      
      # Compile state of outputs
      state = Array.new(self.neurons.count){ |i| self.neurons[i].state }

      # Calculate the current error
      self.last_error = calculate_error(state)

      # Convert state to binary and back to a multi dimensional array
      state = to_binary(state)
      state = state.each_slice(self.pattern_dimensions[:width]).to_a
      self.state = state
      
      self.runs += 1
      
      return {
        :did_change => change, 
        :state => self.state,
        :error => self.last_error
      } 
    end
    
    def calculate_error(current_pattern)
      errors = Array.new(0)
      
      self.patterns.each do |pattern|
        sum = 0
      
        expected = pattern.flatten
        actual = current_pattern
      
        expected.each_with_index do |v, i|
          sum += 1 if expected[i]!=actual[i]
        end
        errors << sum
      end
      return errors
    end
    
    def transfer(activation)
      (activation >= 0 ? 1 : -1)
    end
    
    def to_binary(vector)
      return Array.new(vector.size){|i| ((vector[i] == -1) ? 0 : 1)}
    end
    
  end
end