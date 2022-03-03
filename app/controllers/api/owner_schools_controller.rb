class Api::OwnerSchoolsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @owner = Owner.find(os_params[:owner_id].to_i)

    @owner_school = OwnerSchool.create!(os_params)

    @owner.league.current_draft_pick += 1
    @owner.league.save

    render 'show'
  end

  private

  def os_params
    hash = params.require(:owner_school).permit(:owner_id, :school_id, :draft_pick, :league_id)
  end
end
