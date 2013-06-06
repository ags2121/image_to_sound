require_relative 'ImageFilter'

class PosterizeFilter < ImageFilter

	def initialize
		@name = "posterize"
	end

	def process(input)
		input = input.posterize
	end
end
