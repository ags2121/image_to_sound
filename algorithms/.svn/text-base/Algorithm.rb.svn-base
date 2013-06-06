require 'midilib/sequence'
require 'midilib/consts'
require 'rmagick'
include MIDI

class Algorithm

	TEMPO = 80

	def initialize( image_path )
		@image_path = Dir.pwd+"/images/"+image_path
		@image_name = image_path
		puts "image path: #{@image_path}"
	end

	######
	##BASE CLASS METHODS
	######
	def output_audio
		raw_image_data = read_image
		column_averages = calculate_pixel_column_averages( raw_image_data )
		deltas = calculate_delta_values( column_averages )
		create_mp3( column_averages, deltas )
	end

	def read_image
		Magick::Image.read( @image_path )[0]
	end

	def calculate_pixel_column_averages( raw_image_data )

		vals = {}

		#calculate RGB of EACH pixel
		raw_image_data.each_pixel do |pixel, col, row|
			# puts "Pixel at: #{col}x#{row}:
			# \tR: #{pixel.red}, G: #{pixel.green}, B: #{pixel.blue}"

			if vals[col] == nil
				vals[col] = [ (pixel.red + pixel.green + pixel.blue)/3 ]
			else
			 	vals[col] << ( (pixel.red + pixel.green + pixel.blue)/3 )
			end
		end

		# puts "#{vals}"

		#calculate RGB averages for each column
		average_vals_per_column = []

		vals.each do |key, value|
			average_vals_per_column << (value.inject{|sum, el| sum + el}.to_f / vals.size)
		end
		#puts "avg #{average_vals_per_column}"

		average_vals_per_column
	end

	def calculate_delta_values( average_vals_per_column )
		deltas = []
		average_vals_per_column.each_with_index do |val, index|
			if index == 0
				deltas[index] = val % 256
			else
				deltas[index] = ( (val - deltas[index-1]).abs ) % 256
			end
		end
		#puts "deltas #{deltas}"
		deltas
	end

	def create_mp3( average_vals_per_column, deltas )
		seq = Sequence.new()

		# Create a first track for the sequence. This holds tempo events and stuff
		# like that.
		track = Track.new(seq)
		seq.tracks << track
		track.events << Tempo.new(Tempo.bpm_to_mpq( TEMPO ))
		track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

		# Create a track to hold the notes. Add it to the sequence.
		track = Track.new(seq)
		seq.tracks << track

		# Give the track a name and an instrument name (optional).
		track.name = 'My New Track'
		track.instrument = GM_PATCH_NAMES[0]

		# Add a volume controller event (optional).
		track.events << Controller.new(0, CC_VOLUME, 127)

		#offset = note_value, index allows us to fetch values from the deltas array in parallel
		track.events << ProgramChange.new(0, 1, 0)
		average_vals_per_column.each_with_index do |rgb_average, index|
			#88 key piano has range from A0 (9) to C8 (96)
			offset = rgb_average_to_pitch( rgb_average )

		  	track.events << NoteOn.new(0, offset, 127, 0)
		  	note_length = seq.length_to_delta(delta_to_note( deltas[index] ))
		  	track.events << NoteOff.new(0, offset, 127, note_length)
		end

		output_name = @image_name + "_" + algorithm_name + "_" + Time.now.to_s.split(" ")[0..1].join("_")

		begin
			File.open("#{output_name}.mid", 'wb') { |file| seq.write(file) }
			final_output = Dir.pwd+"/outputted_mp3/"+"#{output_name}.mp3"
			system "fluidsynth -F #{output_name}.raw /usr/share/sounds/sf2/acoustic_grand_piano_ydp_20080910.sf2 #{output_name}.mid"
			system "lame --preset standard #{output_name}.raw #{final_output}"
			system "rm #{output_name}.raw"
			system "mv #{output_name}.mid outputted_midi"
			puts "\nSuccessfully created file!"
		rescue => err
			#puts "#{err}"
			system "rm #{output_name}.mid #{output_name}.raw"
			return nil
		end
		final_output #if write is successful, return audio path
	end


	######
	##METHODS THAT WILL BE OVERIDDEN
	#######
	def delta_to_note(delta)
		raise " method \'delta_to_note\' cannot be called on abstract class \'Algorithm\' "
	end

	def rgb_average_to_pitch( rbg_average )
		raise " method \'rgb_average_to_pitch\' cannot be called on abstract class \'Algorithm\' "
	end

	def algorithm_name
		raise " method \'algorithm_name\' cannot be called on abstract class \'Algorithm\' "
	end

end

