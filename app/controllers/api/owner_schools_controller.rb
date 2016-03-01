class Api::OwnerSchoolsController < ApplicationController
  def create
    @owner_school = OwnerSchool.create(owner_schoool_params)
  end

  def destroy
    owner_school = OwnerSchool.find_by(owner_schoool_params)

    owner_school.destroy
  end

  private

  def owner_schoool_params
    params.require(:owner_school).permit(:owner_id, :school_id)
  end
end
