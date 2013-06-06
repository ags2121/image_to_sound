require 'rmagick'

class ImageFilter

	attr_accessor :name

	def initialize
		@name = ""
	end

	def process(input)
		raise 'cannot process input from abstract base class ImageFilter!'
	end
end
