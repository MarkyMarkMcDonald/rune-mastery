require 'rest_client'
require 'json'

class RuneLookup

  Rune = Struct.new(:id, :name, :type)

  def self.by_id(id)
    api_key = ENV['LOL_API_KEY']
    region = 'na'
    base_url = 'https://na.api.pvp.net'

    rune_info_endpoint = "#{base_url}/api/lol/static-data/#{region}/v1.2/rune/#{id}?runeData=colloq,depth&api_key=#{api_key}"
    rune_info_response = RestClient.get(rune_info_endpoint)
    rune_info = JSON.parse(rune_info_response)

    return Rune.new(id.to_i, rune_info['name'], rune_info['rune']['type'])
  end
end
