require 'rails_helper'

RSpec.describe League do
  let!(:league) { FactoryGirl.create(:league) }
  let!(:old_league) { FactoryGirl.create(:league, :old) }

  describe 'self.old' do
    it 'returns only old leagues' do
      expect(League.old).to eq [old_league]
    end
  end

  describe 'self.current' do
    it 'returns only current leagues' do
      expect(League.current).to eq [league]
    end
  end

  describe 'show_has_paid?' do
    let!(:owner) { FactoryGirl.create(:owner, league: league) }

    it 'is false if no owners have paid' do
      expect(league.show_has_paid?).to be false
    end

    it 'is true if at least one owner has paid' do
      FactoryGirl.create(:owner, has_paid: true, league: league)

      expect(league.show_has_paid?).to be true
    end
  end
end
