class LeaguesController < ApplicationController
  before_action :get_league,
    only: %i(new_invite invite leaderboard bracket draft_room)

  before_action :check_if_in_league, only: %i(leaderboard bracket draft_room)

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
    @schools = School.all
  end

  def draft_room
    draft_room_data
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

  def draft_room_data
    @user_data = {
      league_id: @league.id,
      current_user_id: current_user.id,
      current_owner_id: current_user.owner_for_league(@league).try(:id)
    }
  end

  def league_params
    params.require(:league).permit(:name, :description, :commissioner_id, :password)
  end
end
