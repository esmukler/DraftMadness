class Seed < ActiveRecord::Base
  validates :seed_number, :region, presence: true
  has_one  :school

  WINNING_POINTS = [
    # second round points at stake for each seed 1-16
    [10, 10.6, 11.5, 12.1, 13.7, 13.4, 13.9, 15.1, 14.9, 16.1, 16.6, 16.3, 17.9, 18.5, 19.4, 23],
    # third round...
    [11.3, 13.6, 14.99, 15.50, 16.787, 16.63, 18.35, 19.07, 19.59, 18.13, 18.61, 18.34, 19.50, 19.84, 19.92, 23],
    # sweet 16
    [13.13, 15.33, 17.54, 18.42, 19.33, 18.89, 19.34, 19.32, 19.84, 19.40, 19.51, 19.92, 23, 23, 23, 23],
    # elite 8
    [15.94, 17.85, 18.85, 18.93, 19.49, 19.74, 19.91, 19.57, 19.92, 23, 19.76, 23, 23, 23, 23, 23],
    # final four
    [17.69, 19.012, 19.26, 19.73, 19.80, 19.83, 19.91, 19.74, 23, 23, 23, 23, 23, 23, 23, 23],
    # national championship
    [18.42, 19.67, 19.63, 19.91, 23, 19.91, 19.91, 19.91, 23, 23, 23, 23, 23, 23, 23, 23],
    # total
    [86.49, 96.08, 101.76, 104.59, 112.10, 108.41, 111.34, 112.72, 120.25, 122.63, 120.47, 123.55175, 129.40, 130.34, 131.32, 138]
  ]

  def self.points_for_winning(seed_number, round)
    WINNING_POINTS[round][seed_number - 1]
  end

  def self.points_for_winning_it_all(seed_number)
    WINNING_POINTS[6][seed_number - 1]
  end

  def points_for_winning(round)
    # must -1 to get correct index
    WINNING_POINTS[round][seed_number - 1]
  end
end
