class Owner < ActiveRecord::Base
  include Comparable

  belongs_to :user
  belongs_to :league
  has_many :owner_schools
  has_many :schools, through: :owner_schools

  validates :team_name, :user, :league, presence: true
  validates :user, uniqueness: { scope: :league, message: 'you may only have one owner per league' }

  after_create :set_draft_order

  attr_accessor :league_password

  def total_points
    schools.map(&:total_points).sum.round(2)
  end

  def <=>(other)
    other.total_points - total_points
  end

  def current_ranking
    league.owners.sort.each_with_index do |owner, idx|
      next unless owner.id == id
      return idx + 1
    end
  end

  def score_for_round(round)
    schools.map do |school|
      school.score_for_round(round)
    end.sum.round(2)
  end

  def ppr
    schools.map(&:ppr).sum.round(2)
  end

  def max
    schools.map(&:max).sum.round(2)
  end

  def pick_for(school)
    owner_schools.find_by(school: school).draft_pick
  end

  def commissioner?
    league.commissioner == user
  end

  def set_draft_order
    return unless last_league_member?

    draft_picks = (1..8).to_a.shuffle
    league.owners.each_with_index do |owner, idx|
      owner.update(draft_pick: draft_picks[idx])
    end
  end

  def last_league_member?
    league.owners.count == 8
  end

  def current_turn?
    league.turn_for?(self)
  end

  def selected_regions
    schools.includes(:seed).map(&:region)
  end

  def pending_games
    schools.map(&:games).flatten.uniq.select do |game|
      !game.is_over && game.school1
    end.sort_by do |game|
      game.start_time || Time.now
    end
  end

  def completed_games
    schools.map(&:games).flatten.uniq.select(&:is_over).sort_by do |game|
      game.start_time || Time.now
    end
  end
end
