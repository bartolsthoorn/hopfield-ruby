# Hopfield Network in Ruby

A pure, albeit slow Ruby implementation of a Hopfield Network.

## What is it?
[Hopfield Networks](http://en.wikipedia.org/wiki/Hopfield_network) model the way humans recall memories, or more specific, how neurons recall the pattern. This means you first train the network with a set of known patterns and then pass an unknown or perturbed version of the pattern. The neurons will restore the missing information to create an exact match. 

The patterns can be passed using multi dimensional array of either 0 and 1 or -1 and 1. An artifical neural network will learn the patterns. Now let's move on to an example.

```ruby
gem 'hopfield'
```

## How do I use it?
```ruby
training = Hopfield::Training.new([pattern1, pattern2])
network = Hopfield::Network.new(training, perturbed_pattern)

# Propagate until match
network.propagate until network.associated?

network.pattern # the matched pattern
network.runs # how many propagations it took
```

## TODO
- Make this a C extension to boost performance
- Turn the random picking of neurons into pseudo randomness to prevent the same neuron to be propagated over and over again
- Implement the Storkey learning rule to provide an alternative for the already implemented Hebbian learning rule.
- Release the examples


## Thanks to
I was introduced to Hopfield networks through the book [Clever Algorithms](www.cleveralgorithms.com), and I've borrowed bits of the implementation shown in the book. Also used the `.associated?` syntax found here: [Brain](https://github.com/brainopia/brain).