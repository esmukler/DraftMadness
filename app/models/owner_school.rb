class OwnerSchool < ActiveRecord::Base
  belongs_to :school
  belongs_to :owner
  belongs_to :league

  validates :owner, :school, presence: true
  validates :school, uniqueness: { scope: :league }
  validate :is_valid_pick

  private

  def is_valid_pick
    true
    # if in the first four rounds can't pick two schools from the same region
  end
end
