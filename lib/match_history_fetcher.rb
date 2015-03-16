require 'uri'

class MatchHistoryFetcher
  def fetch(summoner_name)
    summoner_name = summoner_name.downcase.delete(' ')
    summoner_id_endpoint = "#{LOLApiSettings::BASE_URL}/api/lol/#{LOLApiSettings::REGION}/v1.4/summoner/by-name/#{URI.escape(summoner_name)}?api_key=#{LOLApiSettings::API_KEY}"
    summoner_id_response = RestClient.get(summoner_id_endpoint)
    summoner_id = JSON.parse(summoner_id_response)[summoner_name]['id']

    match_history_endpoint = "#{LOLApiSettings::BASE_URL}/api/lol/#{LOLApiSettings::REGION}/v2.2/matchhistory/#{summoner_id}?api_key=#{LOLApiSettings::API_KEY}"
    match_history_response = RestClient.get(match_history_endpoint)
    JSON.parse(match_history_response)['matches']
  end
end
