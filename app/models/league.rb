class League < ApplicationRecord
  validates :name, presence: true
  validate :not_too_many_owners

  belongs_to :commissioner, class_name: 'User'
  has_many :owners, dependent: :destroy
  has_many :users, through: :owners

  has_many :owner_schools, dependent: :destroy
  has_many :schools, through: :owner_schools

  before_save :set_year

  attr_accessor :invite_emails

  MAX_OWNERS = 8

  def self.current
    where(year: Time.now.year)
  end

  def self.old
    where('year < ?', Time.now.year)
  end

  def current?
    year == Time.now.year
  end

  def full?
    owners.count == MAX_OWNERS
  end

  def drafted?
    owner_schools.count == 64
  end

  def drafting?
    School.bracket_announced?(year) &&
      full? && !drafted?
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

  # Returns the owner whose turn it is (snake draft), or nil if draft is over.
  def owner_with_current_turn
    pick = current_draft_pick
    return nil if pick > 64

    cycle = (pick - 1) / 16
    pos = (pick - 1) % 16
    draft_pick = if cycle.even?
      pos < 8 ? pos + 1 : 16 - pos
    else
      pos < 8 ? 8 - pos : pos - 7
    end
    owners.find_by(draft_pick: draft_pick)
  end

  def show_has_paid?
    owners.any?(&:has_paid)
  end

  private

  def not_too_many_owners
    return unless owners.count > MAX_OWNERS
    errors.add(:owners, 'Too many owners!')
  end

  private

  def set_year
    self.year = Time.now.year unless year
  end
end
