require 'thread'

class ImagePipe

	attr_accessor :filter_names

	def initialize
		@operations = Queue.new
		@filter_names = [] #used to keep track of which filters were added; I want to add filters only once
	end

	def add_filter(filter)
		if !@filter_names.include?(filter.name) #ImagePipe silently only adds filters it hasn't seen before
			@operations.enq(filter)
			@filter_names << filter.name
		end
	end

	def execute( image )
		input = image
		while !@operations.empty?
			filter = @operations.deq
			input = filter.process(input)
		end
		@filter_names.clear #empty filter names array
		input
	end

end

# Dir["./image_filters/*.rb"].each {|file| require file }

# pipe = ImagePipe.new

# blur = BlurFilter.new
# pos = PosterizeFilter.new

# res = pipe.add_filter(blur)
# puts "#{res}"
# puts "#{res.class}"
# pipe.add_filter(pos)

# img = Magick::Image.read( "/Users/alejandro/Desktop/photosmall.jpeg" )[0]
# img = pipe.execute(img)
# img.write( "/Users/alejandro/Desktop/photosmall_transformed.jpeg" )
