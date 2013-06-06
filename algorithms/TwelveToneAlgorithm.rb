###### NOTE #####
#while fluidsynth supports quarter-tone midi, it doesn't appear to be the case that midilib supports it
#so actually this wont really produce anything different than the 12_tone algo until midilib can support quarter tones

require_relative 'Algorithm'

class TwelveToneAlgorithm < Algorithm

	def initialize( image_path )
		super( image_path )
	end

	#the twelve tone rhythms will be more granular than the tonal rhythms
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

	#just take the rgb average and mod it into the range of an 88 key piano midi values
	def rgb_average_to_pitch( rgb_average )
		( (rgb_average % 88) + 18 ).round
	end

	def algorithm_name
		"12_tone"
	end

end
