class Trophy < ActiveRecord::Base

  validates :name, :rank, :frequency, :points, presence: true
  before_save :validate_frequency

  MYSQL_TIMEFORMAT = "%Y-%m-%d %H:%M:%S.000000"

  def validate_frequency
    %(weekly monthly yearly).include?( frequency.downcase )
  end

  def rank_to_words
    { '1': 'Gold', '2': 'Silver', '3': 'Bronze' }[ rank.to_s.to_sym ]
  end

  def self.award_most_played_songs( datetime, frequency, station )

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
                         AND ( time BETWEEN '#{ Trophy.epoch_start(datetime, frequency ) }' AND '#{ Trophy.epoch_end(datetime, frequency ) }' )
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

    Award.confer( winning_songs )

  end

  def self.award_most_played_artists( datetime, frequency, station )

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
                          AND ( time BETWEEN '#{ Trophy.epoch_start(datetime, frequency ) }' AND '#{ Trophy.epoch_end(datetime, frequency ) }' )
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

    Award.confer( winning_artists )
  end

  def self.distribute_points( winning_hash )
    point_divisors = winning_hash.collect{ |wh| wh[:rank] }.inject(Hash.new(0)) { |h,e| h[e] += 1 ; h }
    winning_hash.each do |item|
      item[:points] = ( item[:points].to_f / point_divisors[ item[:rank] ])
    end
  end

  def self.epoch_start( datetime, frequency )
    time = case frequency
             when 'week'  then datetime.beginning_of_week
             when 'month' then datetime.beginning_of_month
             when 'year'  then datetime.beginning_of_year
           end

    time.strftime(MYSQL_TIMEFORMAT)
  end

  def self.epoch_end( datetime, frequency )
    time = case frequency
             when 'week'  then datetime.end_of_week
             when 'month' then datetime.end_of_month
             when 'year'  then datetime.end_of_year
           end

    time.strftime(MYSQL_TIMEFORMAT)
  end

end
