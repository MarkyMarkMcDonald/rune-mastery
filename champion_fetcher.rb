class ChampionFetcher
  def fetch(champion_id)
    champion_info_endpoint = "#{LOLApiSettings::BASE_URL}/api/lol/static-data/#{LOLApiSettings::REGION}/v1.2/champion/#{champion_id}?api_key=#{LOLApiSettings::API_KEY}"
    champion_info_response = RestClient.get(champion_info_endpoint)
    JSON.parse(champion_info_response)
  end
end
