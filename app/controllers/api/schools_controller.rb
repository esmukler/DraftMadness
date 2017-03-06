class Api::SchoolsController < ApplicationController
  def bracket
    owner_id = params[:current_owner_id].to_i
    @owner = Owner.find(owner_id)

    @league = @owner.league

    @schools = School.where(year: @league.year).
                      includes(:seed, :owners, :leagues).
                      sort_by do |school|
      [school.seed_number, school.region]
    end
  end
end
