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

matches.each_with_index do |match, index|
  puts '#'*80
  puts "Determining how your runes differed from the pros for match ##{index + 1}"

  champion_id = match['participants'].first['championId']
  champion = ChampionFetcher.new.fetch(champion_id)

  puts "You played #{champion['name']}."

  player_runes = matches.first['participants'].first['runes'].map do |rune|
    {
      rune['runeId'].to_s => rune['rank']
    }
  end.reduce(&:merge)

  games_scraper = SuccessfulGamesScraper.new
  pro_runes = games_scraper.rune_ids(champion['name'])

  comparison = RuneComparator.compare(pro_runes: pro_runes, player_runes: player_runes).map do |rune_id|
    RuneLookup.colloq(rune_id.to_i)
  end
  contrast = RuneComparator.contrast(pro_runes: pro_runes, player_runes: player_runes).map do |key, value|
    {RuneLookup.colloq(key.to_i) => value}
  end

  puts 'Your rune selection'
  puts player_runes
  puts 'Same rune choices'
  puts comparison
  puts 'Differing rune choices'
  puts contrast
  puts '#'*80
end

