class OwnersController < ApplicationController
  before_action :get_league
  before_action :check_if_in_league, only: :show

  def new
    @owner = @league.owners.new
  end

  def create
    @owner = @league.owners.new(owner_params)
    open_sesame = @league.password == params[:owner][:league_password]

    if open_sesame
      if @owner.save
        flash[:notice] = 'Squad successfully created!'
        redirect_to league_leaderboard_path(@owner.league)
      else
        flash[:errors] = @owner.errors.full_messages.join(', ')
        render :new
      end
    else
      flash[:errors] = 'League password was incorrect'
      render :new
    end
  end

  def edit
    @owner = Owner.find(params[:id])
  end

  def update
    @owner = Owner.find(params[:id])

    if @owner.update(owner_params)
      flash[:notice] = 'Squad successfully updated!'
      redirect_to league_owner_path(@league, @owner)
    else
      flash[:errors] = @owner.errors.full_messages.join(', ')
      render :edit
    end
  end

  def show
    @owner = Owner.find(params[:id])
    @schools = @owner.owner_schools.order(:draft_pick).map(&:school)

    @pending_games = @owner.pending_games
    @completed_games = @owner.completed_games
  end

  private

  def owner_params
    params.require(:owner).permit(:team_name, :motto, :user_id, :league_id)
  end
end
