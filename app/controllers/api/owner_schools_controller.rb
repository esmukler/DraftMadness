class Api::OwnerSchoolsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    ActiveRecord::Base.transaction do
      @owner = Owner.find(os_params[:owner_id].to_i)

      @owner_school = OwnerSchool.create!(os_params)

      league = @owner.league
      league.increment!(:current_draft_pick)

      render 'show'
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def os_params
    hash = params.require(:owner_school).permit(:owner_id, :school_id, :draft_pick, :league_id)
  end
end
