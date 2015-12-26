desc 'Award songs or artists'
namespace :awards do

  task weekly: :environment do
    Ceremony.prepare( 'week', DateTime.now.last_week ).perform
  end

  task monthly: :environment do
    Ceremony.prepare( 'month', DateTime.now.last_week ).perform
  end

end
