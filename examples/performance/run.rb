require_relative '../example_helper.rb'
require_relative '../../lib/hopfield'

require 'benchmark'

X = [
  [1, 0, 0, 0, 0, 1],
  [0, 1, 0, 0, 1, 0],
  [0, 0, 1, 1, 0, 0],
  [0, 0, 1, 1, 0, 0],
  [0, 0, 1, 1, 0, 0],
  [0, 1, 0, 0, 1, 0],
  [1, 0, 0, 0, 0, 1]
]
O = [
  [1, 1, 1, 1, 1, 1],
  [1, 0, 0, 0, 0, 1],
  [1, 0, 0, 0, 0, 1],
  [1, 0, 0, 0, 0, 1],
  [1, 0, 0, 0, 0, 1],
  [1, 0, 0, 0, 0, 1],
  [1, 1, 1, 1, 1, 1]
]
F = [
  [1, 1, 1, 1, 1, 1],
  [1, 0, 0, 0, 0, 1],
  [1, 0, 0, 0, 0, 1],
  [1, 0, 0, 0, 0, 1],
  [1, 0, 0, 0, 1, 1],
  [1, 0, 0, 0, 1, 1],
  [1, 1, 1, 1, 1, 1]
]

# Propogate F to O with X and O trained
average_runs = 0
repeat = 1000
time = Benchmark.realtime do
  repeat.times do |i|
    training = Hopfield::Training.new([X, O])
    network = Hopfield::Network.new(training, F)
    network.propagate until network.associated?
    average_runs += network.runs
  end
end
average_runs /= repeat
puts "F [#{F.first.size}x#{F.size}] to O in #{average_runs} an average of propagations"
puts "Time elapsed #{(time*1000).round} milliseconds for #{repeat} trainings and solutions"