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


  desc 'load_offline_draft_result', 'Load an offline draft result via CSV'
  def load_offline_draft_result(league_id, csv)
    raise "Can't find csv input. Please specify valid FILE." unless File.exist?(csv)
    league = League.find(league_id)
    raise "Can't find league. Please specify different league ID" unless league

    ActiveRecord::Base.transaction do
      oss = []
      CSV.foreach(csv, headers: true, header_converters: :symbol) do |row|
        seed = Seed.find_by(seed_number: row[:seed], region: row[:region])
        raise "Can't find seed for #{row}" unless seed
        school = seed.school

        os = create_os(league, school)
        puts("created os for #{school.name}")
        oss.push(os)
      end
    end
  end



  no_commands do
    def get_drafter(current_pick)
      round = (current_pick - 1) / 8
      if round % 2 == 0
        return ((current_pick - 1) % 8) + 1
      else
        return (round * 8 + 9) - current_pick
      end
    end

    def create_os(league, school)
      draft_pick = get_drafter(league.current_draft_pick)
      owner = league.owners.find_by_draft_pick(draft_pick)
      puts(draft_pick) unless owner
      os = OwnerSchool.create(
        owner: owner,
        league: league,
        school: school,
        draft_pick: league.current_draft_pick
      )
      owner.league.current_draft_pick += 1
      owner.league.save
    end
  end
end
