require 'spec_helper'

describe RuneLookup do

  describe '.by_id' do

    before do
      stub_request(:get, /.*na\.api\.pvp\.net\/api\/lol\/static-data\/na\/v1\.2\/rune\/123.*/).to_return(:body =>
        '{ "name": "Awesome Sauce",
            "rune": {
              "isRune": true,
              "tier": "3",
              "type": "red"
            }
        }'
      )
    end

    it 'should return the name, id, and type for the rune with the given id' do
      rune = RuneLookup.by_id(123)
      expect(rune.name).to eq 'Awesome Sauce'
      expect(rune.id).to eq 123
      expect(rune.type).to eq 'red'
    end

    it 'should always return numbers for the id' do
      rune = RuneLookup.by_id('123')
      expect(rune.id).to eq 123
    end
  end
end
