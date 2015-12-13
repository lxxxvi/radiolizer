class ArtistsController < ApplicationController
  def index
    @artists = Artist.all.order(:name)
  end

  def show
    @artist = Artist.find( params[:id] )

=begin
    @songs = Song.select('songs.name AS song_name, songs.id AS song_id, max(broadcasts.time) AS last_played, count(*) as play_count').
                  joins(:broadcasts, :artist).
                  where('artists.id = ?', params[:id] ).
                  group('songs.name, songs.id').
                  order('play_count DESC')
=end
  end

end
