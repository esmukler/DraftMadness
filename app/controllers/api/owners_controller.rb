class Api::OwnersController < ApplicationController
  def index
    @league = League.find(params[:id])
    @owners = @league.owners
  end

  def create
    @owner = Owner.create(owner_params)
  end

  def show
    @owner = Owner.find(params[:id])
  end

  def update
    @owner.update(owner_params)
  end

  private

  def owner_params
    params.require(:owner).permit(:user_id, :league_id, :team_name, :motto, :draft_pick)
  end
end
