require 'rest_client'
require 'json'
require 'pry'
require 'dotenv'

require_relative 'lib/match_summarizer.rb'
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

  MatchSummarizer.new.summarize(match)
end
