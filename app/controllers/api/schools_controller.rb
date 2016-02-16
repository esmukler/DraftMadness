class GamesController < ApplicationController
  def bracket
    @schools = School.all
  end

  def results
  end
end
