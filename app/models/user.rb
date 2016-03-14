class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :invitable

  devise :invitable, :omniauthable, omniauth_providers: [:facebook]

  validates :email, presence: true

  has_many :owners
  has_many :leagues, through: :owners
  has_many :owned_schools, through: :owners, source: :schools

  def self.from_omniauth(auth)
    user = self.find_by(email: auth.info.email)

    omniauth_params = {
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20]
    }

    if user
      user.update(omniauth_params)
    else
      user = self.create(omniauth_params)
    end

    user
  end

  def self.do_something
    params = {
      email: 'a@b.com',
      password: '12345678'
    }
    create(params)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def current_games
    Game.current_games.select do |game|
      school_ids.any? { |x| game.school_ids.include?(x) }
    end
  end

  def owner_for(league)
    owners.find_by(league: league)
  end

  def commissioner?(league)
    self == league.commissioner
  end
end
