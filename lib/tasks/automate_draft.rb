def partial_automate
  league = League.find 3
  schools = get_schools_for(league)

  [20, 22, 14, 21, 16, 24].each do |owner_id|
    owner = Owner.find(owner_id)
    school = schools.detect do |s|
      !owner.selected_regions.include?(s.region)
    end
    chosen_school = schools.delete(school)
    create_os(owner, chosen_school)
  end
end

def automate_draft
  league = League.find(3)
  ids = [24, 16, 21, 14, 22, 20, 23, 17, 17, 23, 20, 22, 14, 21, 16, 24]
  id_index = 0
  schools = get_schools_for(league)
  fake_cdp = league.current_draft_pick

  until schools.empty?
    school = schools.shift
    id = ids[id_index]
    owner = Owner.find(id)
    create_os(owner, school)
    id_index += 1
    id_index -= 16 if id_index >= 16
  end
end

def get_schools_for(league)
  School.all.includes(:seed).select do |school|
    !school.selected_in?(league)
  end.sort_by do |school|
    [school.seed_number, rand(4)]
  end.to_a
end

def fake_create_os(owner, school, cdp)
  puts "-------------#{cdp}#{owner.team_name}-(#{school.seed_number})#{school.name}"
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
