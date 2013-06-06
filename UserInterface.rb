require_relative 'ControlCenter'

class UserInterface

	def initialize
		@control_center = ControlCenter.new
		@user_input = nil, @command = nil, @params = nil, @result = nil
		start_program
	end

	#######
	##MAIN LOGIC OF PROGRAM
	######
	def start_program
		print_welcome_text
		while @user_input != 'q'

			#get image
			res = get_image_from_user
			if res == 'q'
				break
			end

			#apply filters
			if @result
				puts "\nGreat! We have an image. Do you want to apply filters to the image? Type \'y\'' or \'n\'"
				get_input
				if @user_input == 'y' or @user_input == 'Y'
					ret_val = allow_user_to_add_filters
					if ret_val == 'q' 	#if the user wanted to quit within the "add filters" loop
						break
					end
					apply_filters( true )
				elsif @user_input == 'n' or @user_input == 'N'
					puts "\nGotcha."
					apply_filters( false )
				else
					puts "\nDidn't really understand that, but you lost your chance to add filters. Moving on..."
					apply_filters( false )
				end
			else
				puts "\nThere was an error fetching your image. Please restart the program."
				break
			end

			#transfrom image to music
			params = allow_user_to_select_algorithm
			if params == nil
				#user entered 'q', wants to quit
				break
			end

			puts "\nYour transformation is being processed. This may take a second..."
			audio_path = transform_image( params )

			if audio_path == nil
				puts "\nUh oh! There was an error writing your audio. Please check your dependencies and restart the program."
				break
			end

			puts "\nFinished! Would you like to hear your audio?"+
				"\nYou can always find your file later in the \'outputted_sounds\' directory."+
				"\nType \'y\' to listen."
			get_input
			if @user_input == 'y' or @user_input == 'Y'
				system "open #{audio_path}"
				break
			end
		end

		puts "\nGoodbye! Come again."
	end

	#######
	##UI METHODS
	######
	def print_welcome_text
		puts "\nHi! Welcome to Synesthesia; a program that transforms your images to music."+
			"\nPlease type \'get_image\' or your own local image path to start the transformation."+
			"\nType \'q\' at any time to quit."
	end

	def get_input
		@user_input = gets.chomp
	end

	def show_get_image_options
		puts "\nType \'i\' to retrieve the latest \'most interesting\' image on Flickr,"+
			"\nor type in a search query to find your own special image."
	end

	def get_image_from_user
		get_input

		while @result == nil
			if @user_input == "get_image"
				show_get_image_options
				get_input
				@result = @control_center.get_external_image( @user_input )
				if @result == nil
					puts "\nLooks like there was an error downloading your image."+
						"\nCheck your internet connection or provide a path to a local image."
					get_input
				end

			elsif File.exist?(@user_input)
				@result = @control_center.get_local_image( @user_input )
				if @result == nil
					puts "\nDoesn't look like there's an image at that path. Please provide a valid image file."
					get_input
				end

			elsif @user_input == 'q'
				break
			else
				puts "\nThere was no file at that directory. Please type in a proper image path or type \'get_image\'"
				get_input
			end
		end

		if @user_input == 'q'
			return @user_input
		else
			return @result
		end

	end

	def allow_user_to_add_filters
		puts "\nYou can add the following filters to your image: \'blur\', \'emboss\', \'oilpaint\', \'posterize\', \'rotate\', or \'sepia\'."+
			"\nType one in and press enter after. You can enter as many as you like, as long as you press enter after."+
			"\nPress \'done\' when you're finished."
		get_input
		while @user_input != "done" and @user_input != 'q'
			if( @control_center.add_filter(@user_input) == nil ) #if trying to add a filter results in error
				puts "\nYou typed in something weird. No filter was added. Try again."
				get_input
			else
				puts "\n#{@user_input} filter added. Want to add more? Type \'done\' if you're done."
				get_input
			end
		end
		@user_input #return the last thing the user entered
	end

	def apply_filters( did_filter )
		@control_center.execute_filters( did_filter )
	end

	def allow_user_to_select_algorithm
		puts "\nNow for the fun part!\nWhich algorithm would you like to use to transform your image?"+
			"\nType in \'tonal\', \'12_tone\', or \'quarter_tone\'."
		get_input
		while @user_input != 'q'
			if @user_input == "tonal"
				return get_tonal_options
			elsif @user_input == "12_tone" || @user_input == "quarter_tone"
				puts "\n#{@user_input} it is!"
				params = { :algorithm => @user_input }
				return params
			else
				puts "\nYou typed in something weird. No algorithm was selected. Try again."
				get_input
			end
		end
		return nil
	end

	def get_tonal_options
		puts "\nTonal it is! What key signature would you like?\nType in something like \'g# minor\' or \'b major\'. "+
			"\nNo flats please, and major or minor are the only options."
		get_input
		while @user_input != 'q'
			input = @user_input.chomp.split(" ")
			if is_valid_tonal_input( input )
				puts "\n#{@user_input} it is!"
				params = { :algorithm => "tonal", :key => input[0], :tonality => input[1] }
				return params
			else
				puts "\nYou typed in something weird. You still need to specify a key signature. Try again."
				get_input
			end
		end
		return nil #return nil if user enters 'q'
	end

	def is_valid_tonal_input( input )
		@control_center.is_valid_tonal_input( input )
	end


	def transform_image( params )
		@control_center.transform_image( params )
	end

end

ui = UserInterface.new
