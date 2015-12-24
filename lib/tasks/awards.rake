desc 'Award songs or artists'
namespace :awards do

  task weekly: :environment do
    Station.weekly_awards
  end

  task monthly: :environment do
    Station.monthly_awards
  end

end
