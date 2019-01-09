# frozen_string_literal: true

# Nightly rake tasks leveraged by whenever/crontab
namespace :nightly do
  desc 'Update LDAP employees database'
  task employees: :environment do
    Ldap::Queries.employees
  end

  desc 'Remove expired OptOutLinks'
  task expire_links: :environment do
    OptOutLink.audit_expired_links
  end
end
