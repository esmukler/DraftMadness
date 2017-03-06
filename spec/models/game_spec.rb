require 'rails_helper'

RSpec.describe Game do
  let!(:game) { FactoryGirl.create(:game) }
  let!(:old_game) do
    FactoryGirl.create(:game,
                       start_time: nil,
                       school1: old_schools.first,
                       school2: old_schools.last)
  end
  let(:old_schools) do
    [FactoryGirl.create(:school, :old),
     FactoryGirl.create(:school, :old, :florida)]
  end

  describe 'self.from_year' do
    it 'returns only current games if current year used' do
      expect(Game.from_year(Time.now.year)).to eq [game]
    end

    it 'returns only games from specific year if old year used' do
      expect(Game.from_year(Time.now.year - 1)).to eq [old_game]
    end
  end
end
