class Station < ActiveRecord::Base
  has_many :broadcasts
  has_many :songs, through: :broadcasts
  has_many :crawls

  validates :name, presence: true
  validates :name, uniqueness: true

  attr_accessor :play_count

  def top_songs( limit )
    broadcasts.top_songs( limit )
  end

  def top_artists( limit )
    broadcasts.top_artists( limit )
  end

  def play_count
    broadcasts.count
  end

  def song_count
    broadcasts.joins( :song ).group('songs.id').count.count
  end

  def artist_count
    broadcasts.joins( song: :artist ).group('artists.id').count.count
  end

end
