class Schools < Thor
  require './config/environment.rb'
  require 'csv'

  desc 'import_teams', 'Import teams/mascots/seeds by CSV'
  def import_schools(file)
    raise "Can't find csv input. Please specify valid FILE." unless File.exist?(file)

    ActiveRecord::Base.transaction do

      region_order = []
      CSV.foreach(file, headers: true) do |row|
        seed = row['seed'].to_i
        region = row['region']
        name = row['name']
        mascot = row['mascot']
        play_in_game = row['play_in_game'].present?

        region_order << region unless region_order.include? region

        seed = Seed.find_by(
          seed_number: seed,
          region: region,
          play_in_game: play_in_game
        )

        school = School.create!(
          name: name,
          mascot: mascot,
          seed: seed
        )
        puts "#{school.full_name_and_seed} created!"
      end

      # Create 1st round games
      region_order.each do |region|
        Seed::BRACKET_ORDER.each do |seed_num|
          create_first_round_game(region, seed_num)
        end
      end
      puts "first round games created"

      5.times { |num| create_games_for_round(num) }
    end
  end

  private

  def create_games_for_round(round_num)
    games = Game.where(round: round_num).from_year(Time.now.year).order(:id)

    games.each_slice(2) do |game1, game2|
      next_round_game = Game.create!(
        round: (game1.round + 1)
      )
      game1.update(next_game_id: next_round_game.id)
      game2.update(next_game_id: next_round_game.id)
    end
    puts "#{games.last.round_name} finished"
  end

  def create_first_round_game(region, seed_num)
    seed = Seed.find_by(
      seed_number: seed_num,
      region: region
    )
    school1 = seed.school
    school2 = Seed.find_by(
      seed_number: (17 - seed_num),
      region: seed.region
    ).school

    Game.create!(
      school1_id: school1.id,
      school2_id: school2.id,
      round: 0
    )
  end
end
