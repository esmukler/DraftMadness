class Game < ActiveRecord::Base
  validates :round, presence: true

  belongs_to :school1, class_name: 'School'
  belongs_to :school2, class_name: 'School'

  belongs_to :next_game, class_name: 'Game'
  has_many :previous_games, class_name: 'Game', foreign_key: 'next_game_id'

  after_initialize :set_default_start_time

  ROUND_NAMES = [
    'Round of 64', 'Round of 32', 'Sweet 16',
    'Elite 8', 'Final 4', 'Title Game'
  ]

  def self.from_year(year)
    allow_null_sql = "start_time IS NULL OR " if Time.now.year == year
    where("#{allow_null_sql}EXTRACT(YEAR FROM start_time) = #{year}")
  end

  def self.current_games
    where(is_over: false).
    where('start_time < ?', Time.zone.now)
  end

  def self.pending_games
    where.not(is_over: true).
      where.not(school1_id: nil).
      where.not(school2_id: nil).
      order(:start_time)
  end

  def self.completed_games
    where(is_over: true).order(:start_time)
  end

  def round_name
    ROUND_NAMES[round]
  end

  def school_ids
    [school1_id, school2_id].compact
  end

  def schools
    @schools ||= School.where(id: school_ids)
  end

  def started?
    Time.now > start_time
  end

  def winner?(school)
    return unless school
    winning_team_id == school.id
  end

  def winning_school
    School.find_by(id: winning_team_id)
  end

  def year
    start_time.try(:year) || schools.first.year
  end

  def other_previous_game
    return unless next_game
    next_game.previous_games.find { |game| game != self }
  end

  private

  def set_default_start_time
    # set arbitrary late start_time until official starts are announced
    self.start_time = Time.local(Time.now.year, 4, 30) unless self.start_time
  end
end
