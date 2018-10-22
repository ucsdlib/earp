# set :output, "/path/to/my/cron_log.log"
#
# Update the Employee table
every 1.day at: '3:00 am' do
  runner 'Ldap.employees'
end
