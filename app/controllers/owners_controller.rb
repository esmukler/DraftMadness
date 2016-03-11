class OwnersController < ApplicationController
  before_action :get_league
  before_action :check_if_in_league, only: :show

  def new
    @owner = @league.owners.new
  end

  def create
    @owner = @league.owners.new(owner_params)

    if @owner.save
      flash[:notice] = 'Squad successfully created!'
      redirect_to league_leaderboard_path(@owner.league)
    else
      flash[:errors] = @owner.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
    @owner = Owner.find(params[:id])
    @schools = @owner.owner_schools.order(:draft_pick).map(&:school)
  end

  private

  def owner_params
    params.require(:owner).permit(:team_name, :motto, :user_id, :league_id)
  end
end
