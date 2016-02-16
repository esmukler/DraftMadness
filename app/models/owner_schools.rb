class OwnerSchools < ActiveRecord::Base
  validates :owner, :school, presence: true

  belongs_to :owner
  belongs_to :school
end
