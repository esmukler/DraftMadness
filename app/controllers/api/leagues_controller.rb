class Api::LeaguesController < ApplicationController
  def standings
    @league = League.find(params[:league_id])
    @owners = @league.owners.sort_by { |o| o.total_points }
  end
end
