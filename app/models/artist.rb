class Artist < ActiveRecord::Base
  has_many :songs
  has_many :children, class_name: 'Artist', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Artist'
  has_many :awards, as: :awardable
  scope :only_parents, -> { where( 'parent_id IS NULL' ) }
  scope :ordered, -> { order( :name ) }

  validates :name, presence: true
  validates :name, uniqueness: true

  attr_accessor :play_count

  def same_as!( artist )
    self.update!( parent_id: artist.id )
    songs.update_all( artist_id: artist.id ) # point all songs that belonged to "self" to new parent artist
    awards.update_all( awardable_id: artist.id )
  end

  def similar
    new_name = "#{ self.name.split(' ').last } #{ self.name.split(' ')[0..-2].join(' ') }".strip
    [
      Artist.where( '( name LIKE ? OR name LIKE ? ) AND id != ? AND parent_id IS NULL', self.name.gsub(/ /, '%'), new_name, self.id )
    ].flatten.compact
  end

  def self.find_parent_by( attributes )
    found = Artist.find_by( attributes )
    ( found.parent ) ? found.parent : found if found
  end

  def self.find_parent_or_create( attributes )
    found = Artist.find_or_create_by( attributes )
    ( found.parent ) ? found.parent : found
  end

  def songs_ranked
    songs.only_parents.each { |s| s.count_plays ; s }.sort_by{ |s| s.play_count }.reverse
  end

  def count_plays( time_limit = DateTime.new )
      songs.inject(0) { |sum, i| sum += i.count_plays( time_limit ) }
  end

  def count_plays_on( station )
    songs.inject(0) { |sum, i| sum += i.count_plays_on( station ) }
  end

  def self.newest
    Artist.only_parents.order( created_at: :desc ).first
  end

  def oldest_song
    songs.order( created_at: :asc ).first
  end

  def stations
    songs.joins(:stations)
  end

  def last_broadcast
    songs.joins( :broadcasts ).order( 'broadcasts.time DESC' ).first.last_broadcast
  end

  def first_broadcast
    songs.joins( :broadcasts ).order( 'broadcasts.time ASC' ).first.first_broadcast
  end

  def self.most_played
    Broadcast.most_played_artist
  end

  def self.most_songs
    Artist.find( Song.all.group( :artist_id ).order( 'count_all DESC' ).count.take(1).first[0] )
  end

  def last_broadcast_on( station )
    songs.joins( :broadcasts ).where( 'broadcasts.station_id = ?', station.id ).order( 'broadcasts.time DESC' ).first.last_broadcast
  end
end
