class Bracket < Thor
  require './config/environment.rb'

  desc 'fix_final_four_regions SEMI1_REGION1 SEMI1_REGION2 SEMI2_REGION1 SEMI2_REGION2',
      'Reassign Elite 8 games so Final Four semifinals have the correct region matchups
      (e.g. thor bracket:fix_final_four_regions East West South Midwest)'
  def fix_final_four_regions(semi1_region1, semi1_region2, semi2_region1, semi2_region2, year = nil)
    year = (year || Time.now.year).to_i
    semi1_regions = [semi1_region1, semi1_region2]
    semi2_regions = [semi2_region1, semi2_region2]

    r3_games = Game.from_year(year).where(round: 3).order(:id).to_a
    r4_games = Game.from_year(year).where(round: 4).order(:id).to_a

    if r3_games.size != 4 || r4_games.size != 2
      raise "Need exactly 4 Elite 8 and 2 Final Four games for #{year}. Found #{r3_games.size} Elite 8, #{r4_games.size} Final Four."
    end

    e8_by_region = r3_games.each_with_object({}) do |g, h|
      region = regions_feeding_into(g).first
      (h[region] ||= []) << g
    end

    semi1_game = r4_games[0]
    semi2_game = r4_games[1]

    [semi1_regions, semi2_regions].zip([semi1_game, semi2_game]).each do |regions, r4_game|
      regions.each do |region|
        game = e8_by_region[region]&.first
        unless game
          raise "No Elite 8 game found for region '#{region}'. Check spelling; regions in bracket: #{e8_by_region.keys.join(', ')}"
        end
        game.update!(next_game_id: r4_game.id)
      end
    end

    puts "Final Four regions updated for #{year}:"
    puts "  Semi 1: #{semi1_regions.join(' vs ')}"
    puts "  Semi 2: #{semi2_regions.join(' vs ')}"
  end

  desc 'final_four_regions [YEAR]', 'Print which regions feed into each Final Four semifinal (default: current year)'
  def final_four_regions(year = nil)
    year = (year || Time.now.year).to_i
    r4_games = Game.from_year(year).where(round: 4).order(:id).to_a

    if r4_games.empty?
      puts "No Final Four games found for #{year}."
      return
    end

    r4_games.each_with_index do |game, i|
      regions = regions_feeding_into(game)
      puts "Final Four Semi #{i + 1}: #{regions.join(' vs ')}"
    end
  end

  private

  def regions_feeding_into(game)
    if game.round == 0
      [game.schools.first&.region].compact
    else
      game.previous_games.flat_map { |pg| regions_feeding_into(pg) }.uniq
    end
  end
end
