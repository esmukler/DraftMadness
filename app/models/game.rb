class Game < ActiveRecord::Base
  validates :round, presence: true

  belongs_to :school1, class_name: 'School'
  belongs_to :school2, class_name: 'School'

  belongs_to :next_game, class_name: 'Game'
  has_many :previous_games, class_name: 'Game', foreign_key: 'next_game_id'

  ROUND_NAMES = [
    'Second Round', 'Third Round', 'Sweet Sixteen',
    'Elite Eight', 'Final Four', 'Championship'
  ]

  def self.current_games
    where(is_over: false).
    where('start_time < ?', Time.zone.now)
  end

  def round_name
    ROUND_NAMES[round]
  end

  def school_ids
    [school1.id, school2.id]
  end

  def schools
    School.where(id: school_ids)
  end
end
