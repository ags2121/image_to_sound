require "open-uri"
require 'flickraw'
require 'singleton'
FlickRaw.api_key="a0cdf256da5e302856d2270673014046"
FlickRaw.shared_secret="fc5518957b7c13a8"

class DataFetcher
	include Singleton

	attr_accessor :current_downloaded_image_name

	def self.instance
		@@instance ||= new
	end

	def initialize
		# @current_downloaded_image_name = "current_downloaded_image"
	end

	def get_image_by_search( search_term )
		begin
			list = flickr.photos.search :text => search_term, :per_page => 1
			image_name = download_image_from_list( list )
		rescue => err
	 		puts "DataFetcher error - could not download image through search: #{err}"
	 		return nil
		end
		#if successful, return image name
		image_name
	end

	def get_recent_interesting_photo
		begin
			list = flickr.interestingness.getList :per_page => 1
			image_name = download_image_from_list( list )
		rescue => err
			puts "DataFetcher error - could not download image through interestingness: #{err}"
	 		return nil
		end
		#if successful, return image name
		image_name
	end

	def download_image_from_list( list )
		url = FlickRaw.url list[0]
		image_title = list[0].title.tr(' ', '_').gsub(/[()]/, "") #remove spaces and parens
		extension = url[-3..-1] || url
		image_name = "#{image_title}"+'.'+"#{extension}"
		File.write( image_name , open(url).read, {mode: 'wb'})
		image_name
	end

end

# df = DataFetcher.instance
# df.get_recent_interesting_photo
