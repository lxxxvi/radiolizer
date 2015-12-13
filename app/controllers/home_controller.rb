class HomeController < ApplicationController
  def index
    @newest_artist = Artist.newest
    @newest_song   = Song.newest

    @pop_songs      = Broadcast.top_songs(3)
    @pop_artists    = Broadcast.top_artists(3)
  end




end
