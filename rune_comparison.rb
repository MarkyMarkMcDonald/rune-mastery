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

summoner_name = ARGV[0] || 'marksalulz'

matches = MatchHistoryFetcher.new.fetch(summoner_name)

matches.each_with_index do |match, match_index|
  puts '#'*80
  puts "Match ##{match_index + 1}"

  champion_id = match['participants'].first['championId']
  champion = ChampionFetcher.new.fetch(champion_id)

  puts "You played #{champion['name']}."

  puts "Fetching your rune selection..."
  player_runes = matches.first['participants'].first['runes'].map do |rune|
    {
      rune['runeId'].to_s => rune['rank']
    }
  end.reduce(&:merge)

  puts "Fetching multiple pro's rune selection..."
  pro_games = SuccessfulGamesScraper.new.games(champion['name'])

  summaries = pro_games.map do |pro_game|
    pro_runes = pro_game[:runes]
    comparison = RuneComparator.compare(pro_runes: pro_runes, player_runes: player_runes).map do |rune_id|
      RuneLookup.colloq(rune_id.to_i)
    end
    contrast = RuneComparator.contrast(pro_runes: pro_runes, player_runes: player_runes).map do |key, value|
      {RuneLookup.colloq(key.to_i) => value}
    end

    {
      player_name: pro_game[:player_name],
      comparison: comparison,
      contrast: contrast
    }
  end

  puts 'Your rune selection'
  puts player_runes

  summaries.each_with_index do |summary, summary_index|
    puts '-'*80
    puts "Pro ##{summary_index + 1} - #{summary[:player_name]}"

    puts 'Same rune choices'
    puts summary[:comparison]
    puts 'Differing rune choices'
    puts summary[:contrast]
  end
end

