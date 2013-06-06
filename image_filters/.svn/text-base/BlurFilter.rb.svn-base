require_relative 'ImageFilter'

class BlurFilter < ImageFilter

	def initialize
		@name = "blur"
	end

	def process(input)
		input = input.motion_blur(0, 10, 30)
	end
end
