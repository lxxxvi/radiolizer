class Broadcast < ActiveRecord::Base
  belongs_to :station
  belongs_to :song
  belongs_to :crawl

  before_create :set_initial_song_id

  validates :name, :time, :station_id, :song_id, presence: true

  private
  def set_initial_song_id
    self.initial_song_id ||= self.song_id
  end
end
