class Owner < ActiveRecord::Base
  validates :team_name, :user, presence: true

  belongs_to :user
  belongs_to :league
  has_many :owner_schools
  has_many :schools, through: :owner_schools

  def total_points
    owner_schools.map(&:total_points).inject(&:+)
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
end
