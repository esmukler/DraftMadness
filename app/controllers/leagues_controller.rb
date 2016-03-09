class LeaguesController < ApplicationController
  def standings
    @league = League.find(params[:league_id])
  end
end
