require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Find main artist through name variation" do

    artist = Artist.find_parent_or_create( name: "The Rolling Stones" )
    artist_variation  = Artist.find_parent_or_create( name: "Rolling Stones" )
    assert( artist_variation.id == artist.id, "Main artist NOT found with variation of artist's name" )

  end

  test "Change an artist's parent" do

    artist = Artist.find_parent_or_create( name: "The Rolling Stones" )
    artist_variation = Artist.find_parent_or_create( name: "Rolling Stones, The" )
    artist_variation.same_as!( artist )

    assert( artist_variation.parent_id == artist.id, "Parent ID was not updated" )
    assert( Song.find(3).artist_id == artist.id, "Songs of artist_variation has not been updated after same_as()")
  end

end
