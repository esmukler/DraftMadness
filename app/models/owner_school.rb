class OwnerSchool < ActiveRecord::Base
  validates :owner, :school, presence: true
  validate :is_valid_pick

  belongs_to :owner
  belongs_to :school

  private

  def is_valid_pick
    # if in the first four rounds can't pick two schools from the same region
  end
end
