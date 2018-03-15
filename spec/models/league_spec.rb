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

  describe "updating year" do
    it "updates year if no year" do
      league = FactoryGirl.build(:league, year: nil)
      league.save
      expect(league.year).to eq Time.now.year
    end

    it "doesn't change year if year exists" do
      league = FactoryGirl.build(:league, year: 2017)
      league.save
      expect(league.year).to eq 2017
      league.update(name: 'other name')
      expect(league.year).to eq 2017
    end
  end
end
