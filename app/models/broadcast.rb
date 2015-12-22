class Broadcast < ActiveRecord::Base
  belongs_to :station
  belongs_to :song
  belongs_to :crawl

  before_create :set_initial_song_id

  validates :name, :time, :station_id, :song_id, presence: true

  def self.top_songs( limit )

    top_song_ids = Broadcast.all.
                             group( :song_id ).
                             order( 'count_all DESC' ).
                             count.
                             take( limit )

    top_songs = Hash[top_song_ids]

    Song.find( top_songs.collect { |k,v| k } ).
         map{ |s| s.play_count = top_songs[ s.id ] ; s }.
         sort{ |r,l| l.play_count <=> r.play_count }

  end

  def self.top_artists( limit, station = nil )
    top_artist_ids = Broadcast.where('0=0')
    top_artist_ids = top_artist_ids.where( 'broadcasts.station_id = ?', station.id ) if station.present?
    top_artist_ids = top_artist_ids.joins( song: :artist ).
                               group( 'artists.id' ).
                               order( 'count_all DESC' ).
                               count.take( limit )

    top_artists = Hash[top_artist_ids]

    Artist.find( top_artists.collect{ |k,v| k } ).
           map{ |a| a.play_count = top_artists[ a.id ] ; a }.
           sort{ |r,l| l.play_count <=> r.play_count }
  end

  def self.last_play_of( song )
    where( 'broadcasts.song_id = ?', song.id )
  end

  private
  def set_initial_song_id
    self.initial_song_id ||= self.song_id
  end
end
