module Hopfield
  class Network
    attr_accessor :neurons, :patterns, :weights, :state, :pattern_dimensions, :last_error, :runs, :random_pool, :random_pool_index
    
    def initialize(training, perturbed_pattern)
      unless training.class.to_s == 'Hopfield::Training'
        raise TypeError, 'Training has to be an instance of Hopfield::Training'
      end
      
      unless training.patterns.first.size == perturbed_pattern.flatten.size
        raise SyntaxError, 'Given pattern does not match size of the training patterns'
      end
      
      # Turn 0 into -1
      perturbed_pattern = perturbed_pattern.flatten.map { |value| (value == 0 ? -1 : value) }
      
      @neurons =  training.neurons
      @patterns = training.patterns
      @weights =  training.weights
      @pattern_dimensions = training.pattern_dimensions
      
      @neurons.count.times do |i|
        @neurons[i] = perturbed_pattern[i]
      end
      
      # Create a semi random pool to improve performance
      # This prevents propagation of the same neuron over and over again
      @random_pool =        (0...@neurons.count).to_a.shuffle
      @random_pool_index =  rand(@neurons.count)
      
      @last_error = [1]
      @runs =       0
    end
    
    def associated?
      return @last_error.include? 0
    end
    
    def pattern
      return @state
    end
    
    def get_weight(i , j)
      ij = [i, j].sort
      return @weights[ij.first][ij.last]
    end
    
    def propagate
      # Select random neuron
      if @random_pool_index == @random_pool.size - 1
        @random_pool_index = 0
        @random_pool.shuffle!
      end
      
      i = @random_pool[@random_pool_index]
      @random_pool_index += 1
      
      if USE_C_EXTENSION
        output = Hopfield::calculate_neuron_state(i, @neurons, @weights)
      else
        # Ruby equivalent of calculate_neuron_state C function
        activation = 0.0
        @neurons.each_with_index do |other, j|
          next if i == j
          activation += get_weight(i, j)*other
        end
        output = transfer(activation)
      end
      
      change = output != @neurons[i]
      @neurons[i] = output
      
      # Compile state of outputs
      state = @neurons

      # Calculate the current error
      if USE_C_EXTENSION
        @last_error = Hopfield::calculate_state_errors(state, @patterns)
      else
        # Ruby equivalent of calcuting the current error
        @last_error = calculate_error(state)
      end

      # Convert state to binary and back to a multi dimensional array
      state = to_binary(state)
      state = state.each_slice(@pattern_dimensions[:width]).to_a
      @state = state
      
      @runs += 1
      
      return {
        did_change: change, 
        state: @state,
        error: @last_error
      } 
    end
    
    def calculate_error(current_pattern)
      errors = Array.new(0)
      
      @patterns.each do |pattern|
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