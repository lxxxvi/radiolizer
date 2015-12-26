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

end
