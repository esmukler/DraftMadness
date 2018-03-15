class Seed < ApplicationRecord
  validates :seed_number, :region, presence: true
  has_many :schools


  WINNING_POINTS = [
    # R64 points at stake for each seed 1-16
    [10.00, 10.61, 11.59, 11.97, 13.56, 13.71, 13.86, 14.92, 15.08, 16.14, 16.29, 16.44, 18.03, 18.41, 19.39, 23.00],
    # R32...
    [11.36, 13.71, 14.85, 15.23, 16.74, 16.82, 18.11, 19.02, 19.62, 18.26, 18.48, 18.48, 19.55, 19.85, 19.92, 23.00],
    # sweet 16
    [13.03, 15.38, 17.58, 18.41, 19.39, 18.94, 19.24, 19.39, 19.85, 19.39, 19.47, 19.92, 23.00, 23.00, 23.00, 23.00],
    # elite 8
    [15.91, 17.88, 18.86, 19.02, 19.55, 19.77, 19.77, 19.62, 19.92, 19.92, 19.77, 23.00, 23.00, 23.00, 23.00, 23.00],
    # final four
    [17.58, 19.02, 19.32, 19.77, 19.77, 19.85, 19.92, 19.77, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00],
    # national championship
    [18.48, 19.62, 19.70, 19.92, 23.00, 19.92, 19.92, 19.92, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00],
    # total
    [86.36, 96.21, 101.89, 104.32, 112.02, 109.02, 110.83, 112.65, 120.47, 119.71, 120.02, 123.85, 129.58, 130.26, 131.32, 138.00]
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
