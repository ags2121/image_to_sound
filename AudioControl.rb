Dir["./algorithms/*.rb"].each {|file| require file }

class AudioControl

	#naive factory pattern
	def transform_image( image_path, params )
		puts "#{params}"
		puts "#{image_path}"
		algorithm_name = params[:algorithm]
		if algorithm_name == "tonal"
			algorithm = TonalAlgorithm.new( image_path, params[:key], params[:tonality] )
		elsif algorithm_name == "12_tone"
			algorithm = TwelveToneAlgorithm.new( image_path )
		elsif algorithm_name == "quarter_tone"
			algorithm = QuarterToneAlgorithm.new( image_path )
		end
		algorithm.output_audio
	end

	def is_valid_tonal_input( input )
		TonalAlgorithm::KEY.keys.include?( input[0] ) and TonalAlgorithm::TONALITY.keys.include?( input[1] )
	end
end

# ac = AudioControl.new
# ret = ac.is_valid_tonal_input( ["g#", "minor"] )
# puts "#{ret}"
