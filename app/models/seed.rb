class Seed < ApplicationRecord
  validates :seed_number, :region, presence: true
  has_many :schools


  WINNING_POINTS = [
    # R64 points at stake for each seed 1-16
    [10.07, 10.57, 11.5, 12.07, 13.57, 13.71, 13.93, 15.14, 14.86, 16.07, 16.29, 16.43, 17.93, 18.5, 19.43, 19.93],

    # R32...
    [11.43, 13.64, 14.71, 15.29, 16.64, 17.0, 18.07, 19.07, 19.5, 18.36, 18.43, 18.5, 19.57, 19.86, 19.93, 23.0],

    # sweet 16
    [13.07, 15.43, 17.43, 18.5, 19.36, 19.0, 19.29, 19.43, 19.71, 19.43, 19.43, 19.93, 23.0, 23.0, 23.0, 23.0],

    # elite 8
    [15.93, 17.93, 18.79, 19.07, 19.5, 19.79, 19.79, 19.64, 19.93, 19.93, 19.71, 23.0, 23.0, 23.0, 23.0, 23.0],

    # final four
    [17.57, 19.07, 19.21, 19.79, 19.79, 19.86, 19.93, 19.79, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0],

    # national championship
    [18.43, 19.64, 19.71, 19.93, 23.0, 19.93, 19.93, 19.93, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0, 23.0],

    # total
    [86.5, 96.28, 101.35, 104.65, 111.86, 109.29, 110.94, 113.0, 120.0, 119.79, 119.86, 123.86, 129.5, 130.36, 131.36, 134.93]
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
