class Owner < ActiveRecord::Base
  validates :team_name, :user, :league, presence: true

  belongs_to :user
  belongs_to :league
  has_many :owner_schools
  has_many :schools, through: :owner_schools

  def total_points
  end
end
