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