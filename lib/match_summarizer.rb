class MatchSummarizer
  def summarize(match)
    champion_id = match['participants'].first['championId']
    champion = ChampionFetcher.new.fetch(champion_id)
    champion_name = champion['name']

    puts "You played #{champion_name}."

    puts 'Fetching your rune selection...'
    player_runes = match['participants'].first['runes'].map do |rune|
      {
        rune['runeId'].to_s => rune['rank']
      }
    end.reduce(&:merge)

    puts 'Your rune selection'
    player_runes.each do |rune_id, count|
      puts "#{RuneLookup.by_id(rune_id).name}: #{count}"
    end

    puts 'Fetching multiple pro rune selections...'
    pro_games = SuccessfulGamesScraper.new.games(champion_name)

    comparisons = pro_games.map do |pro_game|
      pro_runes = pro_game[:rune_id_counts]

      contrast = RuneComparator.contrast(pro_runes: pro_runes, player_runes: player_runes).map do |rune_id, difference|
        {
          rune_id: {
            rune: RuneLookup.by_id(rune_id),
            difference: difference
          }
        }
      end

      {
        player_runes: player_runes,
        pro_name: pro_game[:player_name],
        contrast: contrast
      }
    end

    comparisons.each.with_index do |summary, summary_index|
      puts '-'*80
      puts "Pro ##{summary_index + 1} - #{summary[:pro_name]}"

      puts 'Differing rune choices'
      summary[:contrast].each do |contrast|
        puts "#{contrast[:rune_id][:difference]}:  #{contrast[:rune_id][:rune].name}"
      end
    end

    {
      comparisons: comparisons,
      champion_name: champion_name,
    }
  end
end
