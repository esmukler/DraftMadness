require 'csv'

class UpdateFirstRoundGameTimes < ApplicationJob
  def perform()
    year = Time.now.year
    filename = "lib/assets/#{year}_first_round_game_times.csv"
    @games =  Game.pending_games.from_year(year)
    @schools = School.current
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      update_game_from_row_data(row)
    end
  end

  private

  def update_game_from_row_data(row)
    begin
      game_schools = find_schools_from_row(row)
      game = @games.find_by_schools(*game_schools)
      update_time(game, row)
    rescue
      puts("error", row)
    end
  end

  def update_time(game, row)
    date = row[:date]
    eastern_time = row[:time]

    # Combine and parse date and time in Eastern Time
    eastern_datetime = Time.strptime("#{date} #{eastern_time}", "%Y-%m-%d %I:%M %p").in_time_zone('Eastern Time (US & Canada)')
    # Convert to Pacific Time
    pacific_datetime = eastern_datetime.in_time_zone('Pacific Time (US & Canada)')
    game.update!(start_time: pacific_datetime)
  end

  def find_schools_from_row(row)
    school_1 = @schools.find_by_slug(row[:school_1])
    school_2 = @schools.find_by_slug(row[:school_2])
    return [school_1, school_2]
  end
end
