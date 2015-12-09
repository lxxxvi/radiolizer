load "#{ Rails.root }/lib/radio_srf_crawler.rb"

desc 'Crawl radio stations'
namespace :crawl do

  @srf_stations = [
      "Radio SRF 1",
      "Radio SRF 2 Kultur",
      "Radio SRF 3",
      "Radio SRF Musikwelle",
      "Radio SRF Virus",
  ]

  task delta: :environment do

    @srf_stations.each do |srf_station|
      srf_crawler = RadioSrfCrawler.new( station_name: srf_station, load_type: 'DELTA' )
      srf_crawler.run
    end
  end

  task full: :environment do
    @srf_stations.each do |srf_station|
      srf_crawler = RadioSrfCrawler.new( station_name: srf_station, load_type: 'FULL' )
      srf_crawler.run
    end
  end

end
