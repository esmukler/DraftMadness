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

  def started?
    first_start_time = games.order(:start_time).first.start_time
    first_start_time && first_start_time < Time.zone.now
  end
end
