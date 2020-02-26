# frozen_string_literal: true

module Ldap
  # LDAP filters to be applied in queries
  class Filters
    # Only show current library staff, excluding students
    # @return [NET::LDAP::Filter] for employees query
    # rubocop:disable Metrics/LineLength
    def self.employees
      Net::LDAP::Filter::FilterParser.parse('(&(objectCategory=user)(memberOf:1.2.840.113556.1.4.1941:=CN=All Library Staff,OU=Groups,OU=University Library,DC=AD,DC=UCSD,DC=EDU))')
    end
    # rubocop:enable Metrics/LineLength

    # Filters for checking if a given user is a library employee
    # @param uid [String] the user id to check. e.g. 'drseuss'
    # @return [NET::LDAP::Filter] for employees query
    def self.library_staff_member(uid)
      Net::LDAP::Filter.eq('SAMAccountName', uid) & employees
    end

    # Only query against the given uid as a member of the hifive ldap group
    # @param uid [String] the user id to check. e.g. 'drseuss'
    # @return [NET::LDAP::Filter] for employees query
    def self.hifive_admin(uid)
      library_staff_member(uid) & Net::LDAP::Filter.eq('memberof', ENV.fetch('APPS_H5_LDAP_GROUP'))
    end
  end
end
