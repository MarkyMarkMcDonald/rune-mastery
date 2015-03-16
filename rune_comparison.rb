require 'rest_client'
require 'json'
require 'pry'
require 'dotenv'

require_relative 'lib/successful_games_scraper.rb'
require_relative 'lib/rune_comparator.rb'
require_relative 'lib/champion_fetcher.rb'
require_relative 'lib/match_history_fetcher.rb'
require_relative 'lib/lol_api_settings.rb'
require_relative 'lib/rune_lookup.rb'

Dotenv.load

matches = MatchHistoryFetcher.new.fetch('jgreubz')

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
