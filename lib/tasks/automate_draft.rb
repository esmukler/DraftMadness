require './config/environment.rb'

def automate_draft(league_id)
  league = League.find(league_id)
  owners = league.owners.sort_by(&:draft_pick)
  owner_idx = 2
  forward_direction = true
  schools = get_schools_for(league)
  fake_cdp = league.current_draft_pick

  ActiveRecord::Base.transaction do
    until schools.empty?
      school = schools.shift
      owner = owners[owner_idx]
      create_os(owner, school)
      owner_idx, forward_direction = update_markers(owner_idx, forward_direction)
    end
  end
end

def update_markers(idx, forward_direction)
  if forward_direction
    if idx == 7
      [7, false]
    else
      [idx + 1, true]
    end
  else
    if idx == 0
      [0, true]
    else
      [idx - 1, false]
    end
  end
end

def fake_create_os(owner, school)
  puts "[#{owner.league.current_draft_pick}]...#{owner.team_name}-(#{school.full_name_and_seed})"
end

def get_schools_for(league)
  School.current.includes(:seed).where.not(id: league.school_ids).sort_by do |school|
    [school.seed_number, rand(4)]
  end
end

def create_os(owner, school)
  os = OwnerSchool.create(
    owner: owner,
    league: owner.league,
    school: school,
    draft_pick: owner.league.current_draft_pick
  )
  owner.league.current_draft_pick += 1
  owner.league.save
end
