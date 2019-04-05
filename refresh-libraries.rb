require 'rest-client'
require 'nokogiri'

ROOT_URL = 'http://172.16.0.75:32400'.freeze
PARAMS = { params: { "X-Plex-Token": ENV['PLEX_API_TOKEN'] } }.freeze

def get_xml(path)
  RestClient.get(
    ROOT_URL + path,
    PARAMS
  )
end

puts 'Scanning all libraries for new items and metadata...'
all_libraries = Nokogiri::XML(get_xml('/library/sections'))
all_libraries.xpath('//Directory/@key').each do |id|
  get_xml("/library/sections/#{id}/refresh")
end

# Don't know how long Plex takes, so sleep for a while so that when 
# people think the task is finished, there's a chance it actually is. 
sleep(5)

puts "Syncing finished."
