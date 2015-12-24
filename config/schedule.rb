# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require File.expand_path(File.dirname(__FILE__) + "/environment")

env :MAILTO, ""
set :output, { standard: "#{ Rails.root }/log/cron.log", error: "#{ Rails.root }/log/cron.err" }

every 5.minutes do
  rake "crawl:delta"
end

every 1.day, at: '11:00 pm' do
  rake "crawl:full"
end

every :monday, at: '3am' do
  rake "awards:weekly"
end

every '10 3 1 * *' do
  rake "awards:monthly"
end