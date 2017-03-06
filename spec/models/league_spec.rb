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
end
