require 'rest_client'
require 'json'
require 'pry'
require_relative './successful_games_scraper.rb'
require_relative './rune_comparator.rb'
require 'dotenv'
Dotenv.load
require_relative './rune_lookup.rb'

module LOLApiSettings
  API_KEY = ENV['LOL_API_KEY']
  REGION = 'na'
  LOLApiSettings::BASE_URL = 'https://na.api.pvp.net'
end

class MatchHistoryFetcher
  def fetch(summoner_name)
    summoner_id_endpoint = "#{LOLApiSettings::BASE_URL}/api/lol/#{LOLApiSettings::REGION}/v1.4/summoner/by-name/#{summoner_name}?api_key=#{LOLApiSettings::API_KEY}"
    summoner_id_response = RestClient.get(summoner_id_endpoint)
    summoner_id = JSON.parse(summoner_id_response)[summoner_name]['id']

    match_history_endpoint = "#{LOLApiSettings::BASE_URL}/api/lol/#{LOLApiSettings::REGION}/v2.2/matchhistory/#{summoner_id}?api_key=#{LOLApiSettings::API_KEY}"
    match_history_response = RestClient.get(match_history_endpoint)
    JSON.parse(match_history_response)['matches']
  end
end

matches = MatchHistoryFetcher.new.fetch('jgreubz')

class ChampionFetcher
  def fetch(champion_id)
    champion_info_endpoint = "#{LOLApiSettings::BASE_URL}/api/lol/static-data/#{LOLApiSettings::REGION}/v1.2/champion/#{champion_id}?api_key=#{LOLApiSettings::API_KEY}"
    champion_info_response = RestClient.get(champion_info_endpoint)
    JSON.parse(champion_info_response)
  end
end

champion_id = matches.first['participants'].first['championId']
champion = ChampionFetcher.new.fetch(champion_id)

player_runes = matches.first['participants'].first['runes'].map do |rune|
  {
    rune['runeId'].to_s => rune['rank']
  }
end.reduce(&:merge)

games_scraper = SuccessfulGamesScraper.new
pro_runes = games_scraper.rune_ids(champion['name'])

puts "For #{champion['name']}"
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
