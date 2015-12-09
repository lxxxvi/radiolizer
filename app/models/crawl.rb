class Crawl < ActiveRecord::Base
  belongs_to :station

  validates :station_id, :reference_time, presence: true
end
