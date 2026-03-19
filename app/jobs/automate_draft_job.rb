class AutomateDraftJob < ApplicationJob
  queue_as :default

  def perform(league_id)
    league = League.find(league_id)
    owners = league.owners.sort_by(&:draft_pick)
    owner_idx, forward_direction = starting_markers(league.current_draft_pick, owners.length)
    schools = get_schools_for(league)

    ActiveRecord::Base.transaction do
      while schools.any?
        school = schools.shift
        owner = owners[owner_idx]
        owner.draft(school)
        owner_idx, forward_direction = update_markers(owner_idx, forward_direction)
      end
    end
  end

  private

  # For an N-owner snake draft:
  # - picks 1..N go 0..N-1
  # - picks N+1..2N go N-1..0
  # - etc.
  #
  # Returns [owner_idx, forward_direction] where forward_direction describes
  # how the index should move *after* making the current pick.
  def starting_markers(current_pick, owner_count)
    raise ArgumentError, "owner_count must be positive" if owner_count <= 0
    raise ArgumentError, "current_pick must be positive" if current_pick.to_i <= 0

    pick_idx = current_pick - 1
    round = pick_idx / owner_count
    pos = pick_idx % owner_count

    if round.even?
      [pos, true]
    else
      [owner_count - 1 - pos, false]
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
end
