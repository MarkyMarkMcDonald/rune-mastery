require 'rest_client'
require 'nokogiri'
require 'uri'

class SuccessfulGamesScraper

  def games(champion_name)
    links = best_game_links(champion_name)
    links.map do |link|
      game_info = Nokogiri::HTML(RestClient.get(link))

      runes = runes_from_document(game_info)
      next if runes.keys.empty?

      player_name = game_info.css('a.block .gold')[1].text

      {
        rune_id_counts: runes,
        player_name: player_name
      }
    end.compact
  end

  private
  def runes_from_document(game_info)
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
