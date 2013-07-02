require 'spec_helper'

describe Hopfield do
  before :each do 
    pattern1 = [[1,1,1],[0,1,0],[0,1,0]]    # T
    pattern2 = [[1,1,1],[0,1,0],[1,1,1]]    # I
    pattern3 = [[1,0,1],[1,0,1],[1,1,1]]    # U
    
    @patterns = [pattern1, pattern2, pattern3]
  end
    
  describe Hopfield::Training do
    before :each do 
      @training_hebbian = Hopfield::Training.new @patterns, Hopfield::HEBBIAN_RULE
      @training_storkey = Hopfield::Training.new @patterns, Hopfield::STORKEY_RULE
    end
    it 'raises error when feeding inconsistent patterns' do
      expect { Hopfield::Training.new [[1, 1], [1]] }.to raise_error 
    end
    it 'transforms binary to classical notation with -1 and 1' do
      training = Hopfield::Training.new [[[0, 1, 0]]]
      training.patterns.first.should == [-1, 1, -1]
    end
    it 'calculates the amount of neurons' do
      @training_hebbian.neurons.count.should == 9
    end
    it 'trains non-square patterns' do
      pattern1 = [[0, 1], [1, 0], [0, 1]]
      pattern2 = [[1, 1], [1, 1], [1, 1]]
      training = Hopfield::Training.new [pattern1, pattern2]
      training.patterns[1].should == pattern2.flatten
    end
  end

  describe Hopfield::Network do 
    before :each do
      training = Hopfield::Training.new @patterns#, Hopfield::STORKEY_RULE
      @perturbed_pattern = [[0,1,1],[0,1,0],[0,1,0]] # T
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
      Timeout::timeout(5) {
        @network.propagate until @network.associated?
      }
      @network.runs.should < 40
      @network.pattern.should == [[1,1,1],[0,1,0],[0,1,0]]  # T
    end
    it 'finds a non-square pertubed pattern' do
      pattern1 = [[0, 1, 0, 1], [1, 1, 1, 1]]
      pattern2 = [[0, 0, 0, 0], [0, 0, 1, 1]]
      training = Hopfield::Training.new [pattern1, pattern2]
      network = Hopfield::Network.new training, [[0, 1, 1, 1], [1, 1, 1, 1]]
      100.times { network.propagate }
      network.pattern.should == pattern1
    end
  end
end