require 'rest_client'
require 'nokogiri'

class SuccessfulGamesScraper

  def rune_ids(champion_name)
    rune_elements = best_game(champion_name).css('.guide-runes .rune-page img')

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

  private

  def best_game(champion_name)
    response = RestClient.get("http://www.probuilds.net/champions/#{champion_name}")
    doc = Nokogiri::HTML(response)

    best_players = doc.css('.champion-search-results .best-players a')

    best_game_link = best_players[0].attribute('href').value

    best_game_response = RestClient.get(best_game_link)

    Nokogiri::HTML(best_game_response)
  end

end
