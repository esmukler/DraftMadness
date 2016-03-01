class School < ActiveRecord::Base
  validates :name, :primary_color, :secondary_color, :seed, presence: true

  belongs_to :seed
  has_many :owner_schools
  has_many :owners, through: :owner_schools
  has_many :games

  def alive?
    !games.map(&:losing_team_id).include?(id)
  end

  def total_points

  end
end
