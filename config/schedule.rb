set :output, { error: "log/cron_error.log", standard: "log/cron_standard.log" }
#
# Update the Employee table
every 1.day at: '3:00 am' do
  runner 'Ldap::Queries.employees'
end

# Remove expired OptOutLinks
every 1.day at: '2:00 am' do
  runner 'OptOutLink.audit_expired_links'
end
