class GamesController < ApplicationController
  before_action :is_admin, only: :admin_games

  def admin_games
    get_years
    @current_year = (params[:year] || Time.now.year).to_i
    @pending_games = Game.pending_games.from_year(@current_year)
    @completed_games = Game.completed_games.from_year(@current_year)
  end

  def update
    game = Game.find(params[:id])
    score1 = params[:game][:school1_score].to_i
    score2 = params[:game][:school2_score].to_i

    winning_team_id = score1 > score2 ? game.school1_id : game.school2_id
    losing_team_id = score1 > score2 ? game.school2_id : game.school1_id

    game.update!(
      school1_score: score1,
      school2_score: score2,
      winning_team_id: winning_team_id,
      losing_team_id: losing_team_id,
      is_over: true
    )

    if game.next_game
      if game.id < game.other_previous_game.id
        game.next_game.update!(school1_id: winning_team_id)
      else
        game.next_game.update!(school2_id: winning_team_id)
      end
    end

    redirect_to admin_games_url(year: game.year)
  end

  def update_time
    game = Game.find(params[:game_id])
    new_time = Time.local(
      game.schools.first.year,
      start_time('month'),
      start_time('date'),
      start_time('hour'),
      start_time('min')
    )
    unless game.update(start_time: new_time)
      flash[:errors] = game.errors.full_messages.join('; ')
    end

    redirect_to admin_games_url
  end

  private

  def is_admin
    unless current_user.admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  # parse the datetime form
  def start_time(part)
    idx = case part
          when 'month'
            2
          when 'date'
            3
          when 'hour'
            4
          when 'min'
            5
          else
            return nil
          end

    params[:game]["start_time(#{idx}i)"]
  end

  def get_years
    @years = School.order(year: :desc).pluck('DISTINCT year')
    @years.unshift(Time.now.year) unless @years.include? Time.now.year
  end
end
