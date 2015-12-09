class Artist < ActiveRecord::Base
  has_many :songs
  has_many :children, class_name: 'Artist', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Artist'

  validates :name, presence: true
  validates :name, uniqueness: true

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

end
