class LeaguesController < ApplicationController
  before_action :get_league

  def leaderboard
  end

  def bracket
    @schools = School.all
  end

  def draft_room
    draft_room_data
  end

  private

  def get_league
    @league = League.find(params[:league_id])
  end

  def draft_room_data
    @user_data = {
      league_id: @league.id,
      current_user_id: current_user.id,
      current_owner_id: current_user.owner_for_league(@league).try(:id)
    }
  end
end
