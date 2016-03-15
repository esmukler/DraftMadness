class LeaguesController < ApplicationController
  before_action :get_league,
    only: %i(new_invite invite leaderboard bracket draft_room points_board)

  before_action :check_if_in_league, only: %i(leaderboard bracket draft_room points_board)

  def index
    @leagues = League.all.order(created_at: :desc).select do |league|
      !league.full? && !current_user.leagues.include?(league)
    end
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)

    if @league.save
      flash[:notice] = 'League successfully created!'
      redirect_to new_league_owner_path(league_id: @league.id)
    else
      flash[:errors] = @league.errors.full_messages.join(', ')
      render :new
    end
  end

  def leaderboard
  end

  def bracket
    # @schools = School.all
  end

  def draft_room
  end

  def points_board
  end

  def new_invite
  end

  def invite
    if params[:league][:invite_emails].present?
      emails = params[:league][:invite_emails].split(/[\s,\n\r]/)

      emails.each do |email|
        # get rid of spaces
        email.gsub!(' ', '')
        next unless email.present? && /.@./.match(email)

        send_invite(email)
      end

      flash[:notice] = 'Invites sent.' unless emails.empty?
    end

    redirect_to league_leaderboard_path(@league)
  end

  private

  def send_invite(email)
    User.invite!(email: email)
  end

  def league_params
    params.require(:league).permit(:name, :description, :commissioner_id, :password)
  end
end
