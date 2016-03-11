class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :authenticate_user!

  def get_league
    @league = League.find(params[:league_id])
  end

  def check_if_in_league
    return if current_user.leagues.include?(@league)

    flash[:error] = "You're out of your league!"
    redirect_to user_path(current_user)
  end
end
