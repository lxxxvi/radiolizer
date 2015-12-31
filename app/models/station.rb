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

  def first_broadcast
    broadcasts.order( time: :asc ).first
  end

  def latest_broadcast
    broadcasts.order( time: :desc ).first
  end

  def count_songs
    broadcasts.joins( :song ).group('songs.id').count.count
  end

  def count_artists
    broadcasts.joins( song: :artist ).group('artists.id').count.count
  end

  def broadcasts_in_week( datetime = DateTime.now )
    broadcasts.where( 'broadcasts.time BETWEEN ? AND ?', datetime.beginning_of_week, datetime.end_of_week )
  end

  def broadcasts_in_month( datetime = DateTime.now)
    broadcasts.where( 'broadcasts.time BETWEEN ? AND ?', datetime.beginning_of_month, datetime.end_of_month )
  end

  def broadcasts_in_year( datetime = DateTime.now )
    broadcasts.where( 'broadcasts.time BETWEEN ? AND ?', datetime.beginning_of_year, datetime.end_of_year )
  end

end
