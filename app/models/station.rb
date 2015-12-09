class Station < ActiveRecord::Base
  has_many :broadcasts
  has_many :songs, through: :broadcasts
  has_many :crawls

  validates :name, presence: true
  validates :name, uniqueness: true
end
