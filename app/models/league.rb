class League < ActiveRecord::Base
  validates :name, :password, :commissioner, presence: true

  belongs_to :commissioner, class_name: 'Owner'
  has_many :owners

  def full?
    owners.count == 8
  end
end
