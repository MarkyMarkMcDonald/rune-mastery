require 'rest_client'
require 'json'
require 'pry'
require_relative './successful_games_scraper.rb'
require_relative './rune_comparator.rb'
require 'dotenv'
Dotenv.load
require_relative './rune_lookup.rb'

api_key = ENV['LOL_API_KEY']
region = 'na'
base_url = 'https://na.api.pvp.net'

summoner_name = 'jgreubz'

summoner_id_endpoint = "#{base_url}/api/lol/#{region}/v1.4/summoner/by-name/#{summoner_name}?api_key=#{api_key}"
summoner_id_response = RestClient.get(summoner_id_endpoint)
summoner_id = JSON.parse(summoner_id_response)[summoner_name]['id']

match_history_endpoint = "#{base_url}/api/lol/#{region}/v2.2/matchhistory/#{summoner_id}?api_key=#{api_key}"
match_history_response = RestClient.get(match_history_endpoint)
match_history = JSON.parse(match_history_response)

champion_id = match_history["matches"].first["participants"].first["championId"]

champion_info_endpoint = "#{base_url}/api/lol/static-data/#{region}/v1.2/champion/#{champion_id}?api_key=#{api_key}"
champion_info_response = RestClient.get(champion_info_endpoint)

champion_name = JSON.parse(champion_info_response)['name']

player_runes = match_history["matches"][0]["participants"][0]["runes"].map do |rune|
  {
    rune['runeId'].to_s => rune['rank']
  }
end.reduce(&:merge)

games_scraper = SuccessfulGamesScraper.new
pro_runes = games_scraper.rune_ids(champion_name)


puts "For #{champion_name}"
puts "pro runes, #{pro_runes}"
puts "your runes, #{player_runes}"

comparison = RuneComparator.compare(pro_runes: pro_runes, player_runes: player_runes).map do |rune_id|
  RuneLookup.colloq(rune_id.to_i)
end
puts "Same rune choices: #{comparison}"

contrast = RuneComparator.contrast(pro_runes: pro_runes, player_runes: player_runes).map do |key, value|
  {RuneLookup.colloq(key.to_i) => value}
end
puts "Differing rune choices: #{contrast}"
