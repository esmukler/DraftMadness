class LeaguesController < ApplicationController
  before_action :get_league

  def leaderboard
  end

  def bracket
    @schools = School.all
  end

  def draft_room
  end

  private

  def get_league
    @league = League.find(params[:league_id])
  end
end
