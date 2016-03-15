class Api::SchoolsController < ApplicationController
  def bracket
    owner_id = params[:current_owner_id].to_i
    @owner = Owner.find(owner_id)

    @league = @owner.league

    @schools = School.all.includes(:seed, :owners, :leagues).sort_by(&:seed_number)
  end
end
