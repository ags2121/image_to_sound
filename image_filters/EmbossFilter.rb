require_relative 'ImageFilter'

class EmbossFilter < ImageFilter

	def initialize
		@name = "emboss"
	end

	def process(input)
		input = input.emboss(2)
	end
end
