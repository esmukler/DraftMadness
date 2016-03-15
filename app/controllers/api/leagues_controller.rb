class Api::LeaguesController < ApplicationController
  before_action :get_league

  def draft_room
    @current_owner = current_user.owner_for(@league)
  end
end
