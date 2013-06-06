require 'rmagick'
require_relative 'ImagePipe'
require_relative 'DataFetcher'
Dir["./image_filters/*.rb"].each {|file| require file }

class ImageControl

	RESIZE_VALUE = 200
	attr_accessor :current_image_path

	def initialize
		@current_image_path = nil
		@image_pipe = nil
	end

	def get_external_image( command )
		if (command=='i')
			@current_image_path = DataFetcher.instance.get_recent_interesting_photo
		else
			@current_image_path = DataFetcher.instance.get_image_by_search( command )
		end
		@current_image_path
	end

	def get_local_image( image_path )
		#The UI checks to make sure that a file exists at the given path, but we should check again to make
		#sure its an image file
		begin
			Magick::Image.read( image_path )[0]
		rescue => err
	 		puts "Local image could not be read as an image file: #{err}"
	 		return nil
		end
		#if successful, set image path
		@current_image_path = image_path
	end

	def open_and_resize
		#check again to make sure we can open the image
		begin
			img = Magick::Image.read( @current_image_path )[0].resize_to_fill( RESIZE_VALUE, RESIZE_VALUE )
		rescue => err
	 		puts "Could not open and resize image from image path: #{err}"
	 		return nil
		end
	end

	def add_filter( filter )
		if @image_pipe == nil
			@image_pipe = ImagePipe.new
		end

		if filter == "blur"
			@image_pipe.add_filter( BlurFilter.new )
		elsif filter == "emboss"
			@image_pipe.add_filter( EmbossFilter.new )
		elsif filter == "oilpaint"
			@image_pipe.add_filter( OilPaintFilter.new )
		elsif filter == "posterize"
			return @image_pipe.add_filter( PosterizeFilter.new )
		elsif filter == "rotate"
			return @image_pipe.add_filter( RotateFilter.new )
		elsif filter == "sepia"
			return @image_pipe.add_filter( SepiaFilter.new )
		else
			return nil
		end
		return "ok"
	end

	def output_filtered_image( did_filter )
		img = open_and_resize

		#execute image_pipe only if user added filters
		if( did_filter )
			img = @image_pipe.execute( img )
		end

		filtered_img_filename = ("processed_" + Time.now.to_s.split(" ")[0..1].join("_") + "_" + img.filename.split("/").last).tr(':', '_')
		puts "filtered image: #{filtered_img_filename}"
		#make sure we can write the filtered image
		begin
			img.write("./images/#{filtered_img_filename}")
		rescue => err
	 		puts "Could not write filtered image to directory: #{err}"
	 		return nil
		end
		#delete original image
		system "rm #{@current_image_path}"
		@current_image_path = filtered_img_filename #point current_image_path to the filtered image now
	end
end

# ic = ImageControl.new
# ic.current_image_path =  "/Users/alejandro/Dropbox/Comp_Sci_Resources/ooarch-work/ags-cspp51050-spr-13/oo_final_project/current_downloaded_image.png"
# ic.output_filtered_image( false )
