class School < ActiveRecord::Base
  validates :name, :primary_color, :secondary_color, :seed, :year, presence: true

  belongs_to :seed
  has_many :owner_schools
  has_many :owners, through: :owner_schools
  has_many :leagues, through: :owner_schools

  before_create :set_year

  def self.current
    where(year: Time.now.year)
  end

  def full_name
    return name unless mascot.present?
    "#{name} #{mascot}"
  end

  def full_name_and_seed
    "No. #{seed.seed_number} #{full_name}"
  end

  def games
    @games = Rails.cache.fetch "school:#{id}:games", expires_in: 1.hour do
      Game.where("school1_id = ? OR school2_id = ?", id, id).
           order(:round).to_a
    end
  end

  def self.left_alive_count
    all.select(&:alive?).count
  end

  def alive?
    @alive = Rails.cache.fetch "school:#{id}:alive", expires_in: 1.hour do
      Game.where(losing_team_id: id).empty? ? true : false
    end
  end

  def total_points
    return 0 unless games.any?

    games.map do |game|
      won?(game) ? seed.points_for_winning(game.round) : 0
    end.sum.round(2)
  end

  def won?(game)
    game.winning_team_id == id
  end

  def started?
    return unless games.any?
    first_start_time = games.first.start_time
    first_start_time && first_start_time < Time.zone.now
  end

  def ppr
    return 0 unless alive? || champ?

    next_game_round = games.any? ? (games.map(&:round).max) : 0
    remaining_rounds = (next_game_round..5).to_a

    remaining_rounds.map do |round|
      seed.points_for_winning(round)
    end.sum.round(2)
  end

  def max
    [total_points, ppr].sum.round(2)
  end

  def score_for_round(round)
    game = games.detect do |gm|
      gm.round == round
    end
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
    owner_ids.include?(owner.id)
  end

  def selected_in?(league)
    league_ids.include?(league.id)
  end

  def champ?
    winners = games.map(&:winning_team_id)
    winners.count == 6 && winners.uniq.count == 1
  end

  def wins_count
    games_count = games.count
    return games_count if champ?

    games_count - 1
  end

  def wins_count_class
    return case wins_count
    when 0
      'no-wins'
    when 1
      'one-win'
    when 2
      'sweet'
    when 3
      'elite'
    when 4
      'final-four'
    when 5
      'title-gamer'
    else
      'champ'
    end
  end

  private

  def set_year
    self.year = Time.now.year
  end
end
