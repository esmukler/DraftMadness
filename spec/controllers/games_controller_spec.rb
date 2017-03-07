require 'rails_helper'

RSpec.describe GamesController do
  context 'signed in as admin' do
    let(:user) { FactoryGirl.create(:user, :admin) }
    let!(:game) do
       FactoryGirl.create(:game, start_time: 3.hours.ago, next_game: next_game)
    end
    let(:next_game) do
      FactoryGirl.create(:game, school1_id: nil, school2_id: nil, round: 1)
    end
    let!(:other_previous_game) do
      FactoryGirl.create(:game, next_game: next_game)
    end

    before do
      sign_in(user)
    end

    describe 'POST /update_game' do
      it 'completes the game and advances the winning team' do
        patch :update, valid_game_update_params


        expect(game.reload.winning_team_id).to eq game.school1_id
        expect(game.losing_team_id).to eq game.school2_id
        expect(game.is_over).to be true
        expect(game.next_game.reload.school1_id).to eq game.school1_id
        expect(response).to redirect_to admin_games_url(year: game.year)
      end

      context 'other preivous game has lower id' do
        it 'adds winner as second school if other previous game has lower id' do
          game.destroy
          game = FactoryGirl.create(:game, start_time: 3.hours.ago, next_game: next_game)

          expect(game.id).to be > other_previous_game.id
          patch :update, valid_game_update_params.merge(id: game.id)

          expect(game.next_game.reload.school2_id).to eq game.school1_id
        end
      end
    end
  end

  context 'signed in as non-admin user' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
    end

    it 'returns 404' do
      expect { get :admin_games }.
        to raise_error(ActionController::RoutingError)
    end
  end

  private

  def valid_game_update_params
    {
      id: game.id,
      game: {
        school1_score: 71,
        school2_score: 68
      }
    }
  end
end
