require 'rest_client'

class RuneLookup
  def self.colloq(id)
    api_key = ENV['LOL_API_KEY']
    region = 'na'
    base_url = 'https://na.api.pvp.net'

    rune_info_endpoint = "#{base_url}/api/lol/static-data/#{region}/v1.2/rune/#{id}?runeData=colloq&api_key=#{api_key}"
    rune_info_response = RestClient.get(rune_info_endpoint)
    rune_info = JSON.parse(rune_info_response)

    rune_info['name']
  end
end
