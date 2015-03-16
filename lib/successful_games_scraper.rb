require 'rest_client'
require 'nokogiri'
require 'uri'

class SuccessfulGamesScraper

  def games(champion_name)
    links = best_game_links(champion_name)
    links.map do |link|
      game_info = Nokogiri::HTML(RestClient.get(link))

      runes = rune_ids(game_info)

      break if runes.keys.empty?

      {runes: runes}
    end
  end

  private
  def rune_ids(game_info)
    rune_elements = game_info.css('.guide-runes .rune-page img')

    rune_elements.map do |rune_element|
      rune_element.attribute('data-tooltip').value.match(/(\d+)/).captures.first
    end.reduce({}) do |memo, rune_id|
      if memo[rune_id]
        memo[rune_id] += 1
      else
        memo[rune_id] = 1
      end
      memo
    end
  end

  def best_game_links(champion_name)
    doc = Nokogiri::HTML(RestClient.get("http://www.probuilds.net/champions/#{URI.escape(champion_name)}"))

    best_players = doc.css('.champion-search-results .best-players a')
    best_players.map do |player|
      player.attribute('href').value
    end
  end

end
