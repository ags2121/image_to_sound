require_relative 'Algorithm'

class QuarterToneAlgorithm < Algorithm

	def initialize( image_path )
		super( image_path )
	end

	#same as twelve_tone
	def delta_to_note( delta )
		if delta < 4
			return (4.0/3.0) #triplet half
		elsif delta < 35
			return 1.0 #quarter
		elsif delta < 66
			return (2.0/3.0) #triplet quarter
		elsif delta < 97
			return 0.5 #eighth
		elsif delta < 128
			return (1.0/3.0) #triplet eighth
		elsif delta < 159
			return 0.25 #sixteenth
		elsif delta < 190
			return (0.5/3) #triplet sixteenth
		elsif  delta < 221
			return  0.125 #thirty-second
		elsif  delta < 252
			return  (0.25/3) #thirty-second triplet
		elsif  delta < 256
			return  0.0625 #sixty-fourth note
		end
	end

	#Similar to 12 tone computation, but allows for quarter tones (i.e. values moded to the closest 0.5)
	def rgb_average_to_pitch( rgb_average )
		( ((rgb_average % 88) + 18)*2 ).round / 2.0
	end

	def algorithm_name
		"quarter_tone"
	end

end
