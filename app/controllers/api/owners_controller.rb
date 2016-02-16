class OwnersController < ApplicationController
  def index
    @league = League.find(params[:id])
    @owners = @league.owners
  end

  def new
    @owner = Owner.new
  end

  def create
    @owner = Owner.new(owner_params)

    if @owner.save
      render :show
    else
      flash[:error] = @owner.errors.full_messages.join(', ')
      redirect_to :new
    end
  end

  def show
    @owners = Owner.find(params[:id])
  end

  private

  def owner_params
    params.require(:owner).permit(:user_id, :league_id, :team_name, :motto, :draft_pick)
  end
end
