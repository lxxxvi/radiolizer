class StationsController < ApplicationController
  def index

    @stations = Station.all

=begin
    @stations = Station.select(' stations.name AS station_name, stations.id AS station_id, count(*) as played_songs').
                        joins( :broadcasts ).
                        all.
                        group( 'stations.name, stations.id' ).
                        order( 'stations.name ASC' )
=end

  end

  def show
    @station = Station.find( params[:id] )

=begin
    # @most_played_all_time = @station.broadcasts.includes( song: :artist ).select('songs.name AS song_name, artists.name AS artist_name, count(*) AS play_count').group('songs.name, artists.name').order('play_count DESC').limit(5)
    sql = <<EOS
SELECT s.id         AS song_id
     , s.name       AS song_name
     , a.id         AS artist_id
     , a.name       AS artist_name
     , max(b.time)  AS last_played
     , count(*)     AS play_count
  FROM broadcasts b
 INNER JOIN songs s ON s.id = b.song_id
 INNER JOIN artists a ON a.id = s.artist_id
 WHERE b.station_id = #{ @station.id }
 GROUP BY s.id, s.name, a.id, a.name
 ORDER BY play_count DESC
 LIMIT 10
EOS
    @most_played_songs = Station.connection.select_all(sql)

    @most_played_artists = Station.select('artists.name AS artist_name, artists.id AS artist_id, max(broadcasts.time) as last_played, count(*) as play_count').
                                   joins(broadcasts: [ song: :artist ] ).
                                   where('stations.id = ?', params[:id] ).
                                   group('artists.name, artists.id').
                                   order('play_count DESC').
                                   limit(10)
=end
    @most_played_artists = @station.top_artists( 10 )

    @most_played_songs = @station.top_songs( 10 )

  end
end
