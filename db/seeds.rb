# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Create Seeds
%w(Midwest West South East).each do |region|
  (1..16).to_a.each do |seed|
    Seed.create!(
      seed_number: seed,
      region: region,
      play_in_game: false
    )
  end
end


# Create 2015 schools from text file
output = IO.read('db/2015_teams.txt')
rows = output.split("\n")

rows.each do |row|
  cells = row.split("\t ")
  region = cells.last
  seed_number = cells[-2].to_i
  seed = Seed.find_by(region: region, seed_number: seed_number)

  school_name =
    if cells.first.include?('Kentucky')
      'Kentucky'
    else
      school_name = cells[1]
    end

  # play in game school
  if seed.school
    seed.update(play_in_game: true)
    other_school = seed.school
    combined_name = "#{school_name}/#{other_school.name}"
    other_school.update(name: combined_name)
  else
    School.create!(name: school_name, seed_id: seed.id)
  end
end

# Create Games
  # Assign schools to Games
  # Connect games to future games

# Create test League

league = League.create!(name: "Playa's Club", description: 'Where the Playas Play', password: 'thebiggityO')

(1..8).to_a.each do |idx|
  user = User.create!(email: "test_#{idx}@example.com", password: 'secret_password')
  owner = user.owners.create!(team_name: "gobruins_#{idx}", motto: "I'm the No. #{idx} best player", league: league)

  league.update(commissioner: owner) if idx == 1
end

puts "Seeds file complete"
