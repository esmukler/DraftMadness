class Game < ActiveRecord::Base
  validates :round, :start_time, presence: true

  belongs_to :school1, class_name: 'School'
  belongs_to :school2, class_name: 'School'

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
end
