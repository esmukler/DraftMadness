class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :omniauthable

  validates :email, :password, presence: true

  has_many :owners
end
