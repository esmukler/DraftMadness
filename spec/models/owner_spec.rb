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

  describe 'completed games' do
    let!(:other_school) { FactoryGirl.create(:school) }
    let!(:game) { FactoryGirl.create(:game, is_over: true) }

    before do
      owner.owner_schools.create(school: game.school1, draft_pick: 1, league: owner.league)
    end

    it "returns only games with owner's schools" do
      expect(owner.completed_games).to eq([game])
    end

    context "if schools are switched" do
      it "still returns games" do
        owners_school = game.school1
        game.school1 = FactoryGirl.create(:school)
        game.school2 = owners_school
        game.save

        expect(owner.completed_games).to eq([game])
      end
    end

    context "if game is not over" do
      before { game.update(is_over: false) }

      it "does not return game" do
        expect(owner.completed_games).to eq([])
      end
    end

    context "if game does not have school in it" do
      before { game.update(school1: other_school) }

      it "does not return game" do
        expect(owner.completed_games).to eq([])
      end
    end
  end
end
