require 'test_helper'

class SongTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

=begin
  test "Test Equality of initial artist ID after creation" do

    song = Song.new( name: "The new song", artist: Artist.first )
    song.save!

    assert( song.artist_id == song.initial_artist_id, "Artist ID is NOT equal to Initial Artist ID after creation" )

  end
=end

  test "Change a song's parent" do

    song = Song.find_parent_or_create( { artist_id: 1, name: 'Gimme Shelter' } )
    song_variation = Song.find_parent_or_create( { artist_id: 1, name: 'Give Me Shelter' } )
    song_variation.same_as!( song )

    assert( song_variation.parent_id = song.id, "Parent ID was not updated" )
    assert( Broadcast.find(2).song_id = song_variation.parent_id, "Broadcast has been updated with new Song ID")
  end

end
