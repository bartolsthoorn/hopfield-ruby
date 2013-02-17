# Hopfield Network in Ruby

## What is it?
[Hopfield Networks](http://en.wikipedia.org/wiki/Hopfield_network) model the way humans recall memories, or more specific, how neurons recall the pattern. This means you first train the network with a set of known patterns and then pass an unknown or perturbed version of the pattern. The neurons will restore the missing information to create an exact match. 

The patterns can be passed using multi dimensional array of either 0 and 1 or -1 and 1. An artifical neural network will learn the patterns. Now let's move on to an example.

## How do I use it?
```ruby
training = Hopfield::Training.new([pattern1, pattern2])
network = Hopfield::Network.new(training, perturbed_pattern)
network.pattern # the matched pattern
network.runs # how many propagations it took
```

## Example with images
See examples/image.rb for a memory association of Charlie Sheen, with a cat hiding him.
```
$ cd examples
$ ruby image.rb
Image 1 is now in an array of [20x20]
Image 2 is now in an array of [20x20]
Hopfield neurons are trained!
Neurons propagated: 1776
Errors: [0]
```
The script also creates black and white pattern images for you.

## Credits
I was introduced to Hopfield networks through the book [Clever Algorithms](www.cleveralgorithms.com), and I've borrowed bits of the implementation shown in the book. Also used the `.associated?` syntax found here: [Brain](https://github.com/brainopia/brain).