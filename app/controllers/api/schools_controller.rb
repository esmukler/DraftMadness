class Api::SchoolsController < ApplicationController
  def bracket
    @schools = School.all
  end

  def show
    @school = School.find(params[:id])
  end
end
