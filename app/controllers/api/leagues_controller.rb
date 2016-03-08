class Api::LeaguesController < ApplicationController
  def create
    @league = League.create(league_params)
    # assign current_user as commissioner?
  end

  def standings
    @league = League.find(params[:league_id])
    @owners = @league.owners.sort_by { |o| o.total_points }
  end
end
