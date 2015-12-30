class Song < ActiveRecord::Base
  belongs_to :artist
  has_many :broadcasts
  has_many :stations, through: :broadcasts
  has_many :children, class_name: 'Song', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Song'
  has_many :awards, as: :awardable

  before_create :set_initial_artist_id

  validates :name, :artist_id, presence: true

  attr_accessor :play_count

  def same_as!( song )
    self.update!( parent_id: song.id )
    Broadcast.where( song_id: self.id ).update_all( song_id: song.id )
  end

  def self.on( station )
    joins( broadcasts: :station ).where( 'stations.name = ?', station.name )
  end

  def on( station )
    broadcasts.joins( :station ).where( 'stations.name = ?', station.name )
  end

  def self.top( limit )
    joins( :broadcasts ).group( 'songs.id' ).order( 'count_all DESC' ).count.take( limit )
  end

  def self.newest
    Song.order( created_at: :desc ).first
  end

  def self.most_played
    Broadcast.most_played_song
  end

  def self.find_parent_or_create( attributes )
    found = Song.find_or_create_by( attributes )
    if found.parent
      Song.find_parent_or_create( attributes )
    else
      found
    end
  end

  def count_plays( time_limit = DateTime.new )
    self.play_count = broadcasts.where('broadcasts.time > ?', time_limit).count
  end


  def count_plays_on( station )
    self.play_count = broadcasts.where( 'broadcasts.station_id = ?', station.id ).count
  end

  def top_stations
    broadcasts_grouped_by_station = broadcasts.group( :station_id ).count

    Station.find( broadcasts_grouped_by_station.collect { |k, v| k } ).
            map{ |s| s.play_count = broadcasts_grouped_by_station[ s.id ] ; s }
  end

  def first_broadcast
    broadcasts.order( time: :asc ).first
  end

  def last_broadcast
    broadcasts.order( time: :desc ).first
  end

  def last_broadcast_on( station )
    on( station ).order( 'broadcasts.time DESC' ).first
  end


  private
  def set_initial_artist_id
    self.initial_artist_id ||= self.artist_id
  end
end
