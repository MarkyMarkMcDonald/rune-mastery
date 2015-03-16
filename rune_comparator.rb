class RuneComparator

  def self.compare(pro_runes:, player_runes:)
    comparison = []
    pro_runes.each do |key, value|
      comparison.push(key) if value == player_runes[key]
    end
    comparison
  end

  def self.contrast(pro_runes:, player_runes:)
    contrast = {}
    pro_runes.each do |key, value|
      player_value = player_runes[key] || 0
      contrast[key] = value - player_value unless value == player_value
    end

    player_runes.each do |key, value|
      contrast[key] = -value unless pro_runes[key]
    end
    contrast
  end
end
