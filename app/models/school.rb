class School < ActiveRecord::Base
  validates :name, :primary_color, :secondary_color, :seed, presence: true

  belongs_to :seed
  has_many :owner_schools
  has_many :owners, through: :owner_schools

  def full_name
    return name unless mascot.present?
    "#{name} #{mascot}"
  end

  def games
    @games = Rails.cache.fetch "school:#{id}:games", expires_in: 1.day do
      Game.where("school1_id = ? OR school2_id = ?", id, id).
           order(:start_time)
    end
  end

  def alive?
    Game.where(losing_team_id: id).empty?
  end

  def total_points
    return 0 unless games.any?

    games.select do |game|
      won?(game)
    end.map do |game|
      seed.points_for_winning(game.round)
    end.sum.round(2)
  end

  def won?(game)
    game.winning_team_id == id
  end

  def started?
    return unless games.any?
    first_start_time = games.order(:start_time).first.start_time
    first_start_time && first_start_time < Time.zone.now
  end

  def ppr
    return 0 unless alive?

    next_game_round = games.any? ? (games.last.round + 1) : 0
    remaining_rounds = (next_game_round..5).to_a

    remaining_rounds.map do |round|
      seed.points_for_winning(round)
    end.sum.round(2)
  end

  def max
    total_points + ppr
  end

  def score_for_round(round)
    game = games.find_by(round: round)
    return 0 unless game && won?(game)

    seed.points_for_winning(round)
  end

  def seed_number
    seed.seed_number
  end

  def region
    seed.region
  end

  def owned_by?(owner)
    OwnerSchool.where(school: self, owner: owner).any?
  end

  def selected_in?(league)
    OwnerSchool.where(school: self, league: league).any?
  end
end
