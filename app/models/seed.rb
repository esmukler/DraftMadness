class Seed < ApplicationRecord
  validates :seed_number, :region, presence: true
  has_many :schools


  WINNING_POINTS = [
    # R64 points at stake for each seed 1-16
    [10.07, 10.59, 11.54, 12.06, 13.46, 13.75, 13.82, 15.00, 15.00, 16.18, 16.25, 16.54, 17.94, 18.46, 19.41, 19.93],

    # R32...
    [11.47, 13.75, 14.85, 15.29, 16.62, 16.91, 18.01, 19.04, 19.49, 18.31, 18.38, 18.53, 19.56, 19.85, 19.93, 23.00],

    # sweet 16
    [13.09, 15.44, 17.50, 18.46, 19.41, 18.97, 19.26, 19.41, 19.71, 19.41, 19.41, 19.93, 23.00, 23.00, 23.00, 23.00],

    # elite 8
    [15.88, 17.94, 18.82, 19.04, 19.56, 19.78, 19.78, 19.63, 19.93, 19.93, 19.71, 23.00, 23.00, 23.00, 23.00, 23.00],

    # final four
    [17.57, 19.04, 19.26, 19.78, 19.78, 19.85, 19.93, 19.78, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00],

    # national championship
    [18.46, 19.63, 19.71, 19.93, 23.00, 19.93, 19.93, 19.93, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00],

    # total
    [86.54, 96.39, 101.68, 104.56, 111.83, 109.19, 110.73, 112.79, 120.13, 119.83, 119.75, 124.0, 129.5, 130.31, 131.34, 134.93]
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
