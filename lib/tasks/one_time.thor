class OneTime < Thor
  require './config/environment.rb'

  desc 'add_year_to_leagues_and_schools', 'Add year attribute to all old leagues'
  def add_year_to_leagues_and_schools
    League.all.each do |league|
      league.update(year: league.created_at.year)
    end
    School.all.each do |school|
      school.update(year: school.created_at.year)
    end
  end
end
