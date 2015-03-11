require_relative '../spec/spec_helper'

describe RuneComparator do
  before do
    @pro_runes = {
      "a" => 5,
      "b" => 10,
      "c" => 15,
      "d" => 20
    }

    @player_runes = {
      "a" => 10,
      "b" => 10,
      "c" => 10,
      "e" => 20
    }
  end

  describe '.compare' do
      it 'finds the runes on which the players agree' do
        comparison = RuneComparator.compare(pro_runes: @pro_runes, player_runes: @player_runes)
        expect(comparison).to match_array(["b"])
      end
  end

  describe '.contrast' do
    it 'finds the runes on which the players disagree' do
      contrast = RuneComparator.contrast(pro_runes: @pro_runes, player_runes: @player_runes)
      expect(contrast["a"]).to eq(-5)
      expect(contrast["c"]).to eq(5)
      expect(contrast["d"]).to eq(20)
      expect(contrast["e"]).to eq(-20)
    end
  end
end
