require 'open-uri'
require 'cgi'
require 'json'

class RadioSrfCrawler

  TARGET_CLASS = ".SonglogPollerTarget"
  LOAD_TYPES   = %w( FULL DELTA )

  DATETIMEFORMAT = '%Y-%m-%dT%H:%M:%S'

  def initialize( args )

    # args:  station_name      MANDATORY
    #        load_type         OPTIONAL   FULL|DELTA     FULL
    #        reference_date    OPTIONAL   *              DateTime.now

    @station        = Station.find_by( name: args[:station_name] )
    @reference_time = args[:reference_time] || DateTime.now
    @load_type      = args[:load_type] || LOAD_TYPES.first
    @epochs         = []

    raise "Station '#{ args[:station_name] }' is unknown " unless @station
    raise "Load type cannot be '#{ @load_type }', allowed are  #{ LOAD_TYPES.join(', ') }" unless LOAD_TYPES.include?(@load_type)

    prepare
  end

  def run
      @crawl = @station.crawls.create( reference_time: @reference_time, load_type: @load_type )

      @epochs.each do |epoch|
        json = open( srf_url_for( epoch ) ).read
        crawl( json )
      end

      @crawl.save!
  end

  private
  def srf_url_for( epoch = @epochs.first )
    nhtml = Nokogiri::HTML( open( @crawl.station.endpoint ).read )
    ul = nhtml.css( TARGET_CLASS ).first
    "#{ ul['data-polling-url'] }#{ ul['data-channel-id'] }.json?fromDate=#{ epoch[:from] }&toDate=#{ epoch[:to] }&page.size=1000"
  end

  def crawl( json )
    broadcasts = JSON.parse( json )['Songlog']

    broadcasts.each do |item|
      broadcast_time = DateTime.parse( item['playedDate'] )
      broadcast = @crawl.station.broadcasts.find_or_initialize_by( time: broadcast_time )

      if broadcast.new_record?
        artist = Artist.find_parent_or_create( name: item['Song']['Artist']['name'] )
        song = artist.songs.find_parent_or_create( name: item['Song']['title'] )
        broadcast.update!( { song: song, name: "#{ song.name } by #{ artist.name }", crawl: @crawl } )
        @crawl.found_broadcasts += 1
      end
    end
  end


  def prepare

    # TODO: multi-day crawling using epochs
    # assume load_type is full
    from = DateTime.new( @reference_time.year, @reference_time.month, @reference_time.day, 0, 0, 0)
    to   = DateTime.new( @reference_time.year, @reference_time.month, @reference_time.day, 23, 59, 59)

    if @load_type == 'DELTA'
      previous_crawl = @station.crawls.where( 'reference_time < ?', @reference_time).order( 'reference_time DESC' ).limit(1).first

      if previous_crawl
        previous_crawl_time = previous_crawl.reference_time.to_datetime
        from.change( hour: previous_crawl_time.hour, minute: previous_crawl_time.minute, second: previous_crawl_time.second )
      end

      to.change( hour: @reference_time.hour , minute: @reference_time.minute, second: @reference_time.second )
    end

    @epochs << { from: from.strftime( DATETIMEFORMAT ), to: to.strftime( DATETIMEFORMAT ) }
  end

end