class Award < ActiveRecord::Base
  belongs_to :trophy
  belongs_to :ceremony
  belongs_to :station
  belongs_to :awardable, polymorphic: true

  def full_award_name
    "<span class=\"#{ trophy.rank_to_words.downcase }\">#{ trophy.rank_to_words }</span> for <b>#{ trophy.name }</b> on #{ station.name } in #{ ceremony.epoch_name } (#{ play_count } plays)"
  end
end
