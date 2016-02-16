class Game < ActiveRecord::Base
  validates :round, :start_time, presence: true

  belongs_to :school1, class_name: 'School'
  belongs_to :school2, class_name: 'School'

  ROUND_NAMES = [
    'Second Round', 'Third Round', 'Sweet Sixteen',
    'Elite Eight', 'Final Four', 'Championship'
  ]

  def round_name
    ROUND_NAMES[round]
  end
end
