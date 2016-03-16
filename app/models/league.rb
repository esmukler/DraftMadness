class League < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :commissioner, class_name: 'User'
  has_many :owners, dependent: :destroy
  has_many :owner_schools, dependent: :destroy

  attr_accessor :invite_emails

  def full?
    owners.count == 8
  end

  def drafted?
    owner_schools.count == 64
  end


  def turn_for?(owner)
    return false unless owner && owner.draft_pick

    owner = owner.draft_pick
    league = current_draft_pick

    (0...4).to_a.map do |cycle|
      start = cycle * 16

      start + owner == league ||
      (start + 17) - owner == league
    end.any?
  end
end
