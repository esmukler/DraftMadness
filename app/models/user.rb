class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable

  devise :omniauthable, omniauth_providers: [:facebook]

  validates :email, :password, presence: true

  has_many :owners
  has_many :leagues, through: :owners

  def self.from_omniauth(auth)
    existing_user = self.find_by(email: auth.info.email)

    omniauth_params = {
      provider: auth.provider,
      uid: auth.uid
    }

    if existing_user
      existing_user.update(omniauth_params)
    else
      omniauth_params.merge!({
        email = auth.info.email
        password = Devise.friendly_token[0, 20]
      })

      create(omniauth_params)
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
