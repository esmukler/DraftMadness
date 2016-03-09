class OwnersController < ApplicationController
  def show
    @owner = Owner.find(params[:id])
    @schools = @owner.owner_schools.order(:draft_pick).map(&:school)
  end
end
