class OwnerSchool < ApplicationRecord
  belongs_to :school
  belongs_to :owner
  belongs_to :league

  validates :owner, :school, presence: true
  validates :school, uniqueness: { scope: :league }

  after_create :make_last_pick_automatically

  def draft_round
    round = draft_pick / 8
    draft_pick % 8 == 0 ? round : round + 1
  end

  private

  def make_last_pick_automatically
    schools_remaining = School.current.filter { |s| !s.selected_in?(league) }
    return if schools_remaining.count > 1

    last_owner = league.owners.find_by(draft_pick: 1)
    last_school = schools_remaining.first
    last_os = self.class.create(
      owner: last_owner,
      league: league,
      school: last_school,
      draft_pick: league.current_draft_pick
    )
    league.current_draft_pick += 1
    league.save
  end
end
