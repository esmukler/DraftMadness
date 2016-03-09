class Seed < ActiveRecord::Base
  validates :seed_number, :region, presence: true
  has_one  :school

  WINNING_POINTS = [
    # second round
    [],
    # third round
    [] #...
  ]
end
