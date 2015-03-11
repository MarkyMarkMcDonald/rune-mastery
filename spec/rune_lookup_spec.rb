require 'spec_helper'

describe RuneLookup do
  it 'should return the colloquial name for the rune with the given id' do
    stub_request(:get, /.*na\.api\.pvp\.net\/api\/lol\/static-data\/na\/v1\.2\/rune\/123.*/).to_return(:body => '{ "name": "Awesome Sauce" }')

    expect(RuneLookup.colloq(123)).to eq 'Awesome Sauce'
  end
end
