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

# Create Games
Seed.where("seed_number <= ?", 8).each do |seed|
  school1 = seed.school
  other_school_seed = Seed.find_by(
    seed_number: (17 - seed.seed_number),
    region: seed.region
  )
  school2 = other_school_seed.school

  Game.create!(
    school1_id: school1.id,
    school2_id: school2.id,
    round: 0
  )
end

# Create other games

# 4.times do |index|
#   # games = Game.where(round: index)
#
#   games.count.times do |idx|
#     next unless idx % 2 == 0
#     game = games[idx]
#
#     next_round_game = Game.create!(
#       round: (game.round + 1)
#     )
#     game.update(next_game_id: next_round_game.id)
#
#     other_game = games[idx + 1]
#     other_game.update(next_game_id: next_round_game.id)
#   end
# end

# Create test League

league = League.create!(name: "Playa's Club", description: 'Where the Playas Play', password: 'thebiggityO')

(1..8).to_a.each do |idx|
  user = User.create!(email: "test_#{idx}@example.com", password: 'secret_password')
  owner = user.owners.create!(team_name: "gobruins_#{idx}", motto: "I'm the No. #{idx} best player", league: league)

  league.update(commissioner: user) if idx == 1
end

puts "Seeds file complete"
