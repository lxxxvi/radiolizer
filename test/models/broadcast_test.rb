require 'test_helper'

class BroadcastTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Test equality of initial song ID after creation" do

    new_broadcast = Broadcast.new( name: "The new song by The new artist" )
    new_broadcast.save!

    assert( new_broadcast.song_id == new_broadcast.initial_song_id, "Song ID is NOT equal to Initial Song ID after creation" )

  end

end
