set :output, { error: "log/cron_error.log", standard: "log/cron_standard.log" }
# potentially use this for prod?
# set :output, lambda { "2>&1 | logger -t high_five_cron" }
#
# Update the Employee table
every 1.day, at: '3:00 am' do
  rake "nightly:employees"
end

# Remove expired OptOutLinks
every 1.day, at: '2:00 am' do
  rake "nightly:expire_links"
end
