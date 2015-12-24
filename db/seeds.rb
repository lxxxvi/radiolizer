# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

stations = Station.create( [
   { name: "Radio SRF 1",          endpoint: "http://www.srf.ch/radio-srf-1/programm/musik" } ,
   { name: "Radio SRF 2 Kultur",   endpoint: "http://www.srf.ch/radio-srf-2-kultur/programm/musik" } ,
   { name: "Radio SRF 3",          endpoint: "http://www.srf.ch/radio-srf-3/programm/musik" } ,
   { name: "Radio SRF Musikwelle", endpoint: "http://www.srf.ch/radio-srf-musikwelle/programm/musik" } ,
   { name: "Radio SRF Virus",      endpoint: "http://www.srf.ch/radio-srf-virus/programm/musik" }
  ] )

trophies = Trophy.create( [
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 1,  frequency: 'week',   points:  13 },
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 2,  frequency: 'week',   points:   8 },
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 3,  frequency: 'week',   points:   5 },
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 1,  frequency: 'month',  points:  55 },
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 2,  frequency: 'month',  points:  34 },
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 3,  frequency: 'month',  points:  21 },
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 1,  frequency: 'year',   points: 987 },
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 2,  frequency: 'year',   points: 610 },
   { name: 'Most Played Songs',     applicable_on: 'songs',    rank: 3,  frequency: 'year',   points: 377 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 1,  frequency: 'week',   points:   5 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 2,  frequency: 'week',   points:   3 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 3,  frequency: 'week',   points:   2 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 1,  frequency: 'month',  points:  21 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 2,  frequency: 'month',  points:  13 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 3,  frequency: 'month',  points:   8 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 1,  frequency: 'year',   points: 377 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 2,  frequency: 'year',   points: 233 },
   { name: 'Most Played Artists',   applicable_on: 'artists',  rank: 3,  frequency: 'year',   points: 144 }
])