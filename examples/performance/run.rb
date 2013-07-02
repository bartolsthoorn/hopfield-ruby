require_relative '../example_helper.rb'
require_relative '../../lib/hopfield'

require 'benchmark'

X = [
  [1, 0, 0, 0, 1],
  [0, 1, 0, 1, 0],
  [0, 0, 1, 0, 0],
  [0, 0, 1, 0, 0],
  [0, 1, 0, 1, 0],
  [1, 0, 0, 0, 1]
]
O = [
  [1, 1, 1, 1, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 1, 1, 1, 1]
]
F = [
  [1, 1, 1, 1, 1],
  [1, 1, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 1, 1],
  [1, 0, 0, 1, 1],
  [1, 1, 1, 1, 1]
]

# Propogate F to O with X and O trained
average_runs = 0
time = Benchmark.realtime do
  100.times do |i|
    training = Hopfield::Training.new([X, O])
    network = Hopfield::Network.new(training, F)
    network.propagate until network.associated?
    average_runs += network.runs
  end
end
average_runs /= 100
puts "F to O in #{average_runs} an average of propagations"
puts "Time elapsed #{time*1000} milliseconds"