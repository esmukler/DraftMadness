class SchoolsController < ApplicationController
  def show
    @school = School.find(params[:id])
    @pending_games = []
    @completed_games = []

    @school.games.each do |game|
      if game.is_over
        @completed_games << game
      else
        @pending_games << game
      end
    end
  end
end
