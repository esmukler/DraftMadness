class League < ActiveRecord::Base
  validates :name, presence: true
  validate :not_too_many_owners

  belongs_to :commissioner, class_name: 'User'
  has_many :owners, dependent: :destroy
  has_many :owner_schools, dependent: :destroy
  has_many :schools, through: :owner_schools

  attr_accessor :invite_emails

  MAX_OWNERS = 8

  def full?
    owners.count == MAX_OWNERS
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

  private

  def not_too_many_owners
    return unless owners.count > MAX_OWNERS
    errors.add(:owners, 'Too many owners!')
  end
end
