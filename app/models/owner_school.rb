class OwnerSchool < ActiveRecord::Base
  belongs_to :school
  belongs_to :owner
  belongs_to :league

  validates :owner, :school, presence: true
  validates :school, uniqueness: { scope: :league }

  def draft_round
    round = draft_pick / 8
    draft_pick % 8 == 0 ? round : round + 1
  end
end
