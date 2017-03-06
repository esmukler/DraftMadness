require 'rails_helper'

RSpec.describe Owner do
  let(:user)       { FactoryGirl.create(:user) }
  let!(:owner)      { FactoryGirl.create(:owner, user: user, league: league) }
  let!(:old_owner)  { FactoryGirl.create(:owner, user: user, league: old_league) }
  let(:league)     { FactoryGirl.create(:league) }
  let(:old_league) { FactoryGirl.create(:league, :old) }

  describe 'self.current' do
    it 'returns only owners in current leagues' do
      expect(user.owners.current).to eq [owner]
    end
  end

  describe 'self.old' do
    it 'returns only owners in old leagues' do
      expect(user.owners.old).to eq [old_owner]
    end
  end
end
