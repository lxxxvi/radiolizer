class Ceremony < ActiveRecord::Base
  has_many :awards

  validates :frequency, :epoch_start, :epoch_end, :epoch_name, presence: true

  def perform
    revoke_awards unless self.new_record?

    save!

    Station.all.each do |station|
      award_most_played_artists( epoch_start, frequency, station )
      award_most_played_songs( epoch_start, frequency, station )
    end
  end

  def self.prepare( frequency, time )
    epoch = Ceremony.epoch( frequency, time )
    Ceremony.find_or_initialize_by( frequency: frequency, epoch_start: epoch[:start], epoch_end: epoch[:end], epoch_name: epoch[:name] )
  end

  def self.epoch( frequency, time )
    case frequency.downcase
      when 'week'  then
        {
            start: time.beginning_of_week,
            end: time.end_of_week,
            name: "Week #{ time.strftime("%U") } / #{ time.strftime("%Y") }"
        }
      when 'month' then
        {
            start: time.beginning_of_month,
            end: time.end_of_month,
            name: "Month #{ time.strftime("%B") } #{ time.strftime("%Y") }"
        }
      when 'year'  then
        {
            start: time.beginning_of_year,
            end: time.end_of_year,
            name: "Year #{ time.strftime("%Y") }"
        }
      else
        :invalid_frequency_error
    end
  end

  private
  def revoke_awards
    awards.delete_all
  end

  def award_most_played_songs( datetime, frequency, station )

    song_id_sql = <<EOF
    SELECT ranking.song_id
         , trophies.id
         , ranking.play_count
      FROM (
             SELECT b.song_id
                  , b.play_count
                  , @prev := @curr
                  , @curr := b.play_count
                  , @rank := IF(@prev = @curr, @rank, @rank + 1) AS rank
               FROM (
                      SELECT COUNT(*)     AS play_count
                           , song_id      AS song_id
                        FROM broadcasts
                       WHERE station_id = #{ station.id }
                         AND ( time BETWEEN '#{ epoch_start }' AND '#{ epoch_end }' )
                    GROUP BY song_id
                    ORDER BY play_count DESC
                    ) b
                  , ( SELECT @curr := null, @prev := null, @rank := 0 ) tmp_tbl
              WHERE b.play_count > 3
           ) ranking
     INNER JOIN trophies     ON trophies.rank = ranking.rank
                            AND trophies.frequency = '#{ frequency }'
                            AND trophies.applicable_on = 'songs'
EOF

    winning_song_ids = ActiveRecord::Base.connection.execute(song_id_sql)
    winning_songs = winning_song_ids.map { |row| { station: station, item: Song.find(row[0]), trophy: Trophy.find(row[1]), play_count: row[2], datetime: datetime } }

    confer( winning_songs )

  end

  def award_most_played_artists( datetime, frequency, station )

    artist_id_sql = <<EOF
     SELECT ranking.artist_id
          , trophies.id
          , ranking.play_count
       FROM (
              SELECT b.artist_id
                   , b.play_count
                   , @prev := @curr
                   , @curr := b.play_count
                   , @rank := IF(@prev = @curr, @rank, @rank + 1) AS rank
                FROM (
                       SELECT COUNT(*)         AS play_count
                            , songs.artist_id  AS artist_id
                         FROM broadcasts
                   INNER JOIN songs   ON broadcasts.song_id = songs.id
                        WHERE station_id = #{ station.id }
                          AND ( time BETWEEN '#{ epoch_start }' AND '#{ epoch_end }' )
                     GROUP BY songs.artist_id
                     ORDER BY play_count DESC
                     ) b
                   , ( SELECT @curr := null, @prev := null, @rank := 0 ) tmp_tbl
               WHERE b.play_count > 3
             ) ranking
       INNER JOIN trophies     ON trophies.rank = ranking.rank
                              AND trophies.frequency = '#{ frequency }'
                              AND trophies.applicable_on = 'artists'
EOF

    winning_artist_ids = ActiveRecord::Base.connection.execute(artist_id_sql)
    winning_artists = winning_artist_ids.map { |row| { station: station, item: Artist.find(row[0]), trophy: Trophy.find(row[1]), play_count: row[2], datetime: datetime } }

    confer( winning_artists )
  end


  def confer( winners )
    winners.each do |winner|
      if winner[:item].is_a?(Artist) || winner[:item].is_a?(Song)
        winner[:item].awards.build( station_id: winner[:station].id,
                                    trophy_id: winner[:trophy].id,
                                    ceremony: self,
                                    play_count: winner[:play_count] ).save!
      else
        raise('winner[:item] is not an Artist or Song')
      end
    end
  end

end
