require_relative 'Algorithm'

class TonalAlgorithm < Algorithm

	attr_accessor :TONALITY, :KEY

	TONALITY = { "major" => [0, 2, 4, 5, 7, 9, 11, 12],
				"minor" => [0, 2, 3, 5, 7, 8, 10, 12] }

	KEY = { "a" => 21, "a#" =>22, "b"=>23, "b#"=>24, "c"=>25, "c#"=>26,
			"d"=>27, "e" =>28, "f"=>29, "f#"=>30, "g"=>31, "g#"=>32 }

	def initialize( image_path, key, tonality )
		super( image_path )
		@midi_values = output_midi_values_in_key_signature( key, tonality )
	end

	def delta_to_note( delta )
		if delta < 40
			return (2.0) #half
		elsif delta < 116
			return 1.0 #quarter
		elsif delta < 186
			return 0.5 #eighth
		elsif delta < 256
			return 0.25 #sixteenth
		end
	end

	def rgb_average_to_pitch( rgb_average )
		closest_midi_value_to( rgb_average )
	end

	def algorithm_name
		"tonal"
	end

	######
	##METHODS PARTICULAR TO TONAL ALGORITHMS
	######
	def output_midi_values_in_key_signature( key, tonality )
		starting_pitch_val = KEY[ key ]

		final_values = []
		8.times do |oct|
			TONALITY[ tonality ].each do |step|
				if starting_pitch_val + (step + 12*oct) > 108
					break
				end
				final_values << starting_pitch_val + (step + 12*oct)
			end
		end
		final_values
	end

	def closest_midi_value_to( rgb_average )
		rgb_val_in_range = ( (rgb_average % 88) + 18 ).round
		closest_int( @midi_values, rgb_val_in_range )
	end

	def closest_int( array, value)
		index = (0...array.size).bsearch {|x| array[x] >= value }
		if index==nil
			return array.last
		end
		array[index]
	end

end

# keys = TonalAlgorithm::TONALITY
# puts "#{keys.keys}"

# ta = TonalAlgorithm.new("poo", "major",  "a")
# res = ta.closest_int( [1,2,3], 4)
# puts "#{res}"
