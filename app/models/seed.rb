class Seed < ApplicationRecord
  validates :seed_number, :region, presence: true
  has_many :schools

  WINNING_POINTS = [
    # second round points at stake for each seed 1-16
    [10.00, 10.63, 11.64, 12.03, 13.59, 13.59, 13.91, 15, 15, 16.09, 16.41, 16.41, 17.97, 18.36, 19.38, 23],
    # third round...
    [11.33, 13.67, 14.92, 15.39, 16.64, 16.72, 18.20, 19.06, 19.61, 18.20, 18.52, 18.44, 19.53, 19.84, 19.92, 23],
    # sweet 16
    [13.05, 15.31, 17.58, 18.44, 19.38, 18.91, 19.30, 19.38, 19.84, 19.38, 19.53, 19.92, 23, 23, 23, 23],
    # elite 8
    [15.94, 17.81, 18.91, 18.98, 19.53, 19.77, 19.84, 19.61, 19.92, 19.92, 19.77, 23, 23, 23, 23, 23],
    # final four
    [17.66, 18.98, 19.30, 19.77, 19.77, 19.84, 19.92, 19.77, 23, 23, 23, 23, 23, 23, 23, 23],
    # national championship
    [18.52, 19.61, 19.69, 19.92, 23, 19.92, 19.92, 19.92, 23, 23, 23, 23, 23, 23, 23, 23],
    # total
    [86.48, 96.02, 102.03, 104.53, 111.91, 108.75, 111.09, 112.73, 120.38, 119.59, 120.22, 123.77, 129.50, 130.20, 131.30, 138]
  ]

  BRACKET_ORDER = [1, 8, 5, 4, 6, 3, 7, 2]

  def school
    @school ||= schools.find_by(year: Time.now.year)
  end

  def self.points_for_winning(seed_number, round)
    WINNING_POINTS[round][seed_number - 1]
  end

  def self.points_for_winning_it_all(seed_number)
    WINNING_POINTS.last[seed_number - 1]
  end

  def points_for_winning(round)
    # must -1 to get correct index
    WINNING_POINTS[round][seed_number - 1]
  end
end
