class Game < ActiveRecord::Base
  validates :round, presence: true

  belongs_to :school1, class_name: 'School'
  belongs_to :school2, class_name: 'School'

  belongs_to :next_game, class_name: 'Game'
  has_many :previous_games, class_name: 'Game', foreign_key: 'next_game_id'

  ROUND_NAMES = [
    'Round of 64', 'Round of 32', 'Sweet 16',
    'Elite 8', 'Final 4', 'Title Game'
  ]

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
    [school1.id, school2.id]
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
end
