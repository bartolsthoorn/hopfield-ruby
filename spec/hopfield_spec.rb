require 'spec_helper'

describe Hopfield do
  before :each do 
    pattern1 = [[1,1,1],[-1,1,-1],[-1,1,-1]]  # T
    pattern2 = [[1,1,1],[-1,1,-1],[1,1,1]]    # I
    pattern3 = [[1,-1,1],[1,-1,1],[1,1,1]]    # U
    
    @patterns = [pattern1, pattern2, pattern3]
  end
  
  describe Hopfield::Training do
    before :each do 
      @training = Hopfield::Training.new @patterns
    end
    it 'raises error when feeding inconsistent patterns' do
      expect { Hopfield::Training.new [[1, 1], [1]] }.to raise_error 
    end
    it 'calculates the amount of neurons' do
      @training.neurons.count.should == 9
    end
    it 'stored the patterns properly' do
      @training.patterns.should == @patterns
    end
  end

  describe Hopfield::Network do 
    before :each do
      training = Hopfield::Training.new @patterns
      @perturbed_pattern = [[-1,1,1],[-1,1,-1],[-1,1,-1]] # T
      @network = Hopfield::Network.new training, @perturbed_pattern
    end
    it 'raises error when feeding wrong type of training' do
      expect { Hopfield::Network.new 'wrong', @perturbed_pattern }.to raise_error
    end
    it 'finds T for a pertubed pattern of a T' do
      100.times { @network.propagate }
      @network.runs.should == 100
      @network.pattern.should == [[1,1,1],[0,1,0],[0,1,0]]  # T
    end
    it 'finds T for a pertubed pattern of a T using associated?' do
      @network.propagate until @network.associated?
      @network.runs.should < 50
      @network.pattern.should == [[1,1,1],[0,1,0],[0,1,0]]  # T
    end
  end
end