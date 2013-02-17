module Hopfield
  class Network
    attr_accessor :neurons, :patterns, :state, :pattern_width, :vector, :last_error, :runs
    
    def initialize(training, perturbed_pattern)
      unless training.class.to_s == 'Hopfield::Training'
        raise TypeError, 'Training has to be an instance of Hopfield::Training'
      end
      
      unless training.patterns.first.size == perturbed_pattern.size
        raise SyntaxError, 'Given pattern does not match size of the training patterns'
      end
      
      # Turn 0 into -1
      perturbed_pattern.map {|value| (value == 0 ? -1 : value) }
      
      self.neurons =  training.neurons
      self.patterns = training.patterns
      self.pattern_width = training.pattern_width
      self.vector =   perturbed_pattern.flatten
      self.neurons.each_with_index { |neuron,i| neuron.output = self.vector[i] }
      
      self.last_error = [1]
      self.runs =       0
    end
    
    def associated?
      return self.last_error.include? 0
    end
    
    def pattern
      return self.state
    end
    
    def propagate
      # Select random neuron
      i = rand(self.neurons.size)
      activation = 0
      self.neurons.each_with_index do |other, j|
        activation += other.weights[i]*other.output if i!=j
      end
      output = transfer(activation)
      change = output != self.neurons[i].output
      self.neurons[i].output = output
      
      # Compile state of outputs
      state = Array.new(self.neurons.size){|i| self.neurons[i].output}
      
      # Calculate the current error
      self.last_error = calculate_error(state)
      
      # Convert state to binary and back to a multi dimensional array
      state = to_binary(state)
      state = state.each_slice(self.pattern_width).to_a
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
      return Array.new(vector.size){|i| ((vector[i]==-1) ? 0 : 1)}
    end
    
  end
end