class Song < ActiveRecord::Base
  belongs_to :artist
  has_many :broadcasts
  has_many :stations, through: :broadcasts
  has_many :children, class_name: 'Song', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Song'

  before_create :set_initial_artist_id

  validates :name, :artist_id, presence: true

  def same_as!( song )
    self.update!( parent_id: song.id )
    Broadcast.where( song_id: self.id ).update_all( song_id: song.id )
  end

  def self.find_parent_or_create( attributes )
    found = Song.find_or_create_by( attributes )
    if found.parent
      Song.find_parent_or_create( attributes )
    else
      found
    end
  end

  private
  def set_initial_artist_id
    self.initial_artist_id ||= self.artist_id
  end
end
