require 'dotenv'

require_relative 'lib/match_summarizer.rb'
require_relative 'lib/match_history_fetcher.rb'

Dotenv.load

summoner_name = ARGV[0] || 'marksalulz'

matches = MatchHistoryFetcher.new.fetch(summoner_name)

matches.each_with_index do |match, match_index|
  puts '#'*80
  puts "Match ##{match_index + 1}"

  MatchSummarizer.new.summarize(match)
end
