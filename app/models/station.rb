class Station < ActiveRecord::Base
  has_many :broadcasts
  has_many :songs, through: :broadcasts
  has_many :crawls

  validates :name, presence: true
  validates :name, uniqueness: true

  attr_accessor :play_count

  def top_songs( limit )
    broadcasts.top_songs( limit )
  end

  def top_artists( limit )
    broadcasts.top_artists( limit )
  end

  def play_count
    broadcasts.count
  end

  def song_count
    broadcasts.joins( :song ).group('songs.id').count.count
  end

  def artist_count
    broadcasts.joins( song: :artist ).group('artists.id').count.count
  end

  def broadcasts_in_week( datetime = DateTime.now )
    broadcasts.where( 'broadcasts.time BETWEEN ? AND ?', datetime.beginning_of_week, datetime.end_of_week )
  end

  def broadcasts_in_month( datetime = DateTime.now)
    broadcasts.where( 'broadcasts.time BETWEEN ? AND ?', datetime.beginning_of_month, datetime.end_of_month )
  end

  def broadcasts_in_year( datetime = DateTime.now )
    broadcasts.where( 'broadcasts.time BETWEEN ? AND ?', datetime.beginning_of_year, datetime.end_of_year )
  end

  def self.weekly_awards( datetime = DateTime.now.last_week )
    Station.all.each do |station|
      Trophy.award_most_played_artists( datetime, 'week', station )
      Trophy.award_most_played_songs( datetime, 'week', station )
    end
  end

  def self.monthly_awards( datetime = DateTime.now.last_month )
    Station.all.each do |station|
      Trophy.award_most_played_artists( datetime, 'month', station )
      Trophy.award_most_played_songs( datetime, 'month', station )
    end
  end

  def self.yearly_awards( datetime = DateTime.now.last_year )
    Station.all.each do |station|
      Trophy.award_most_played_artists( datetime, 'year', station )
      Trophy.award_most_played_songs( datetime, 'year', station )
    end
  end

end
