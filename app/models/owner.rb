class Owner < ActiveRecord::Base
  validates :team_name, :user, presence: true

  belongs_to :user
  belongs_to :league
  has_many :owner_schools
  has_many :schools, through: :owner_schools

  def total_points
    schools.map(&:total_points).sum
  end

  def current_ranking
    return nil unless schools.map(&:started?).any?

    league.owners.sort do |a,b|
      b.total_points - a.total_points
    end.each_with_index do |owner, idx|
      next unless owner.id == id
      return idx + 1
    end
    nil
  end

  def score_for_round(round)
    schools.map do |school|
      school.score_for_round(round)
    end.sum
  end

  def ppr
    schools.map(&:ppr).sum
  end

  def max
    schools.map(&:ppr).sum
  end

  def pick_for(school)
    owner_schools.find_by(school: school).draft_pick
  end
end
