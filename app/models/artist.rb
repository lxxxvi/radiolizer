class Artist < ActiveRecord::Base
  has_many :songs
  has_many :children, class_name: 'Artist', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Artist'

  validates :name, presence: true
  validates :name, uniqueness: true

  attr_accessor :play_count

  def same_as!( artist )
    self.update!( parent_id: artist.id )
    Song.where( artist_id: self.id ).update_all( artist_id: artist.id ) # point all songs that belonged to "self" to new parent artist
  end

  def self.find_parent_or_create( attributes )
    found = Artist.find_or_create_by( attributes )
    if found.parent
      return Artist.find_parent_or_create( found.parent_id )
    else
      found
    end
  end

  def total_plays
      songs.inject(0) { |sum, i| sum += i.total_plays }
  end

  def total_plays_on( station )
    songs.inject(0) { |sum, i| sum += i.total_plays_on( station ) }
  end

  def self.newest
    Artist.order( created_at: :desc ).first
  end

  def oldest_song
    songs.order( created_at: :asc ).first
  end

end
