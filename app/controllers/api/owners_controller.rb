class Api::OwnersController < ApplicationController
  def index
    @league = League.find(params[:league_id])
    @owners = @league.owners.order(:draft_pick)
  end
end
