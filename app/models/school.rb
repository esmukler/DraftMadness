class School < ActiveRecord::Base
  validates :name, :primary_color, :secondary_color, :seed, presence: true

  belongs_to :seed
  has_many :owner_schools
  has_many :owners, through: :owner_schools

  def full_name
    return name unless mascot.present?
    "#{name} #{mascot}"
  end

  def games
    Game.where("school1_id = ? OR school2_id = ?", id, id)
  end

  def alive?
    !games.map(&:losing_team_id).include?(id)
  end

  def total_points
    0
  end

  def started?
    first_start_time = games.order(:start_time).first.start_time
    first_start_time && first_start_time < Time.zone.now
  end

  def ppr
    0
  end

  def max
    total_points + ppr
  end

  def score_for_round(round)
    game = games.find_by(round: round)
    return 0 unless game && game.winning_team_id == id

    seed.points_for(round)
  end

  def seed_number
    seed.seed_number
  end

  def region
    seed.region
  end
end
