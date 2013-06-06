require_relative 'ImageControl'
require_relative 'AudioControl'

class ControlCenter

	def initialize
		@image_control = ImageControl.new
		@audio_control =  AudioControl.new
	end

	def get_external_image( command )
		@image_control.get_external_image( command )
	end

	def get_local_image( image_path )
		@image_control.get_local_image( image_path )
	end

	def add_filter( filter )
		@image_control.add_filter( filter )
	end

	def execute_filters( did_filter )
		@image_control.output_filtered_image( did_filter )
	end

	def is_valid_tonal_input( input )
		@audio_control.is_valid_tonal_input( input )
	end

	def transform_image( params )
		current_image_path = @image_control.current_image_path
		@audio_control.transform_image( current_image_path, params )
	end

end
