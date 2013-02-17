require 'chunky_png'

require_relative '../lib/hopfield'

def is_dark?(color)
  ChunkyPNG::Color.r(color) +
  ChunkyPNG::Color.g(color) +
  ChunkyPNG::Color.b(color) < 210
end

@runs = 1

def black_and_white_array(image)
  array = Array.new
  image.width.times do |x|
    array[x] = Array.new
    image.height.times do |y|
      if is_dark? image[x,y]
        image[x,y] = ChunkyPNG::Color.rgba(0, 0, 0, 255)
        array[x][y] = 1
      else
        image[x,y] = ChunkyPNG::Color.rgba(255, 255, 255, 255)
        array[x][y] = -1
      end
    end
  end
  image.save("#{@runs}_#{Time.now.to_i.to_s}.png", :fast_rgba)
  @runs += 1
  return array
end

# Image 1, the face of Charlie Sheen
image1 = ChunkyPNG::Image.from_file('image1.png')
array1 = black_and_white_array(image1)

# Image 2, suddenly a wild cat appeared, is that still Charlie in the back?
image2 = ChunkyPNG::Image.from_file('image2.png')
array2 = black_and_white_array(image2)

puts "Image 1 is now in an array of [#{array1.first.size}x#{array1.size}]"
puts "Image 2 is now in an array of [#{array2.first.size}x#{array2.size}]"

# Train with the first image
training = Hopfield::Training.new([array1])

puts "Hopfield neurons are trained!"

# Setup network with the noisy pattern, the second image
network = Hopfield::Network.new(training, array2)

# Propagate till match
network.propagate until network.associated?

# How many runs did it take?
puts "Neurons propagated: " + network.runs.to_s

puts "Errors: " + network.last_error.inspect
