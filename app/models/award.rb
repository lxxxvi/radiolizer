class Award < ActiveRecord::Base
  belongs_to :trophy
  belongs_to :station
  belongs_to :awardable, polymorphic: true

  def self.confer( winners )
    Award.cleanup( winners )

    winners.each do |winner|
      epoch = Award.frequency_to_epoch( winner[:trophy].frequency, winner[:datetime] )

      if winner[:item].is_a?(Artist) || winner[:item].is_a?(Song)
        winner[:item].awards.build( station_id: winner[:station].id,
                                    trophy_id: winner[:trophy].id,
                                    epoch: epoch,
                                    play_count: winner[:play_count] ).save!
      else
        raise('winner[:item] is not an Artist or Song')
      end
    end

  end

  def self.cleanup( winners )
    winners.each do |winner|
      epoch = Award.frequency_to_epoch( winner[:trophy].frequency, winner[:datetime] )

      Award.delete_all_by( { station: winner[:station], trophy: winner[:trophy], epoch: epoch } )
    end
  end

  def full_award_name
    "<span class=\"#{ trophy.rank_to_words.downcase }\">#{ trophy.rank_to_words }</span> for <b>#{ trophy.name }</b> on #{ station.name } in #{ epoch } (#{ play_count } plays)"
  end

  def self.frequency_to_epoch( frequency, datetime )
    case frequency.downcase
      when 'week'  then "Week #{ datetime.strftime("%U") } / #{ datetime.strftime("%Y") }"
      when 'month' then "Month #{ datetime.strftime("%B") } #{ datetime.strftime("%Y") }"
      when 'year'  then "Year #{ datetime.strftime("%Y") }"
    end
  end

  def self.delete_all_by( args )
    Award.where( args ).delete_all
  end

end
