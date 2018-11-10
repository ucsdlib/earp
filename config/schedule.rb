# set :output, "/path/to/my/cron_log.log"
#
# Update the Employee table
every 1.day at: '3:00 am' do
  runner 'Ldap::Queries.employees'
end

# Remove expired OptOutLinks
every 1.day at: '2:00 am' do
  runner 'OptOutLink.audit_expired_links'
end
