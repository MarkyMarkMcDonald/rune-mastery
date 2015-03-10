# require 'sinatra'
require 'rest_client'
require 'json'
require 'pry'

api_key = ENV['LOL_API_KEY']
region = 'na'
base_url = 'https://na.api.pvp.net'

summoner_name = 'jgreubz'

summoner_id_endpoint = "#{base_url}/api/lol/#{region}/v1.4/summoner/by-name/#{summoner_name}?api_key=#{api_key}"

summoner_id_response = RestClient.get(summoner_id_endpoint)

summoner_id = JSON.parse(summoner_id_response)[summoner_name]['id']

# puts summoner_id

match_history_endpoint = "#{base_url}/api/lol/#{region}/v2.2/matchhistory/#{summoner_id}?api_key=#{api_key}"

match_history_response = RestClient.get(match_history_endpoint)

masteries = JSON.parse(match_history_response)["matches"][0]["participants"][0]["masteries"]
runes = JSON.parse(match_history_response)["matches"][0]["participants"][0]["runes"]

puts runes
puts masteries
