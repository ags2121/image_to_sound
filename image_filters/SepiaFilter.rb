require_relative 'ImageFilter'

class SepiaFilter < ImageFilter

	def initialize
		@name = "sepia"
	end

	def process(input)
		input = input.sepiatone
	end
end
