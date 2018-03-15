require 'rails_helper'

RSpec.describe Game do
  let!(:game) { FactoryGirl.create(:game) }
  let!(:old_game) do
    FactoryGirl.create(:game,
                       start_time: 1.year.ago,
                       school1: old_schools.first,
                       school2: old_schools.last)
  end
  let(:other_school) { FactoryGirl.create(:school) }
  let(:old_schools) do
    [FactoryGirl.create(:school, :old),
     FactoryGirl.create(:school, :old, :florida)]
  end

  describe '::from_year' do
    it 'returns only current games if current year used' do
      expect(Game.from_year(Time.now.year)).to eq [game]
    end

    it 'returns only games from specific year if old year used' do
      expect(Game.from_year(Time.now.year - 1)).to eq [old_game]
    end
  end

  describe '::find_by_schools' do
    it 'returns the proper game with schools in one order' do
      expect(described_class.find_by_schools(game.school1, game.school2)).to eq game
    end

    it 'returns the proper game with schools in reverse order' do
      expect(described_class.find_by_schools(game.school2, game.school1)).to eq game
    end

    it "returns nil if schools don't match any game" do
      expect(described_class.find_by_schools(game.school2, other_school)).to be_nil
    end
  end
end
