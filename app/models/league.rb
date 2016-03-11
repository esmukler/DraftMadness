class League < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :commissioner, class_name: 'User'
  has_many :owners, dependent: :destroy

  def full?
    owners.count == 8
  end
end
