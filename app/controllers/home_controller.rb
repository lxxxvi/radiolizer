class HomeController < ApplicationController
  def index
    @newest_artist = Artist.newest
    @newest_song   = Song.newest
   # @awarded_songs    = Award.joins(:trophy).where('trophies.applicable_on = ?', 'songs').order(created_at: :desc).limit( 5 )
   # @awarded_artists  = Award.joins(:trophy).where('trophies.applicable_on = ?', 'artists').order(created_at: :desc).limit( 5 )
  end

end
