require 'csv'

# Create schools and seeds from CSV file
filename = 'db/2016_teams.csv'

CSV.foreach(filename, headers: true) do |row|
  seed = row['seed'].to_i
  region = row['region']
  name = row['name']
  mascot = row['mascot']
  play_in_game = row['play_in_game'].present?

  seed = Seed.create!(
    seed_number: seed,
    region: region,
    play_in_game: play_in_game
  )

  school = School.create!(
    name: name,
    mascot: mascot,
    seed: seed
  )
end

regions = Seed.pluck('distinct region')

# Create 1st round games
regions.each do |region|
  Seed::BRACKET_ORDER.each do |seed_num|
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

5.times do |round_num|
  games = Game.where(round: round_num)

  games.each_slice(2) do |game1, game2|
    next_round_game = Game.create!(
      round: (game1.round + 1)
    )
    game1.update(next_game_id: next_round_game.id)
    game2.update(next_game_id: next_round_game.id)
  end
end

# Create test League

league = League.create!(name: "Playa's Club", description: 'Where the Playas Play', password: 'thebiggityO')

(1..8).to_a.each do |idx|
  user = User.create!(email: "test_#{idx}@example.com", password: 'secret_password')
  owner = user.owners.create!(team_name: "gobruins_#{idx}", motto: "I'm the No. #{idx} best player", league: league)

  if idx == 1
    league.update(commissioner: user)
    user.update(is_admin: true)
  end
end

puts "Seeds file complete"
