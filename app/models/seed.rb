class Seed < ApplicationRecord
  validates :seed_number, :region, presence: true
  has_many :schools


  WINNING_POINTS = [
    # R64 points at stake for each seed 1-16
    [10.07, 10.63, 11.53, 12.15, 13.54, 13.75, 13.96, 15.07, 14.93, 16.04, 16.25, 16.46, 17.85, 18.47, 19.38, 19.93],

    # R32...
    [11.46, 13.68, 14.79, 15.35, 16.6, 17.01, 18.06, 19.03, 19.51, 18.4, 18.33, 18.47, 19.58, 19.86, 19.86, 23.0],

    # sweet 16
    [13.06, 15.49, 17.43, 18.54, 19.38, 18.96, 19.31, 19.44, 19.72, 19.44, 19.38, 19.86, 23.0, 23.0, 23.0, 23.0],

    # elite 8
    [15.9, 17.92, 18.82, 19.1, 19.51, 19.79, 19.79, 19.65, 19.93, 19.93, 19.65, 23.0, 23.0, 23.0, 23.0, 23.0],

    # final four
    [17.5, 19.1, 19.24, 19.79, 19.79, 19.86, 19.93, 19.79, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0],

    # national championship
    [18.4, 19.65, 19.72, 19.93, 23.0, 19.93, 19.93, 19.93, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0],

    # total
    [86.39, 96.47, 101.53, 104.86, 111.82, 109.3, 110.98, 112.91, 120.09, 119.81, 119.61, 123.79, 129.43, 130.33, 131.24, 134.93]
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
