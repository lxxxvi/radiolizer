class Award < ActiveRecord::Base
  belongs_to :trophy
  belongs_to :ceremony
  belongs_to :station
  belongs_to :awardable, polymorphic: true

end
