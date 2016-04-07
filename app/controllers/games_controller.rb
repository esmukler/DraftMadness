class GamesController < ApplicationController
  before_action :is_admin, only: :admin_games

  def admin_games
    @pending_games = Game.pending_games
    @completed_games = Game.completed_games
  end

  def update
    game = Game.find(params[:id])
    score1 = params[:game][:school1_score].to_i
    score2 = params[:game][:school2_score].to_i

    if score1 > score2
      winning_team_id = game.school1_id
      losing_team_id = game.school2_id
    else
      winning_team_id = game.school2_id
      losing_team_id = game.school1_id
    end

    game.update!(
      school1_score: score1,
      school2_score: score2,
      winning_team_id: winning_team_id,
      losing_team_id: losing_team_id,
      is_over: true
    )

    if game.next_game
      if game.next_game.school1_id
        game.next_game.update!(school2_id: winning_team_id)
      else
        game.next_game.update!(school1_id: winning_team_id)
      end
    end

    redirect_to admin_games_url
  end

  private

  def is_admin
    unless current_user.admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
