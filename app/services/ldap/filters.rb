# frozen_string_literal: true

module Ldap
  # LDAP filters to be applied in queries
  class Filters
    # Only show current library staff, excluding students
    # @return [NET::LDAP::Filter] for employees query
    def self.employees
      employees_only = Net::LDAP::Filter.pres('EmployeeID')
      staff = Net::LDAP::Filter.eq('ObjectCategory', 'person')
      users = Net::LDAP::Filter.eq('ObjectClass', 'user')
      no_lib_accounts = Net::LDAP::Filter.ne('sAMAccountName', 'lib-*')
      employees_only & staff & users & no_lib_accounts
    end

    # Filters for checking if a given user is a library employee
    # @param uid [String] the user id to check. e.g. 'drseuss'
    # @return [NET::LDAP::Filter] for employees query
    def self.library_staff_member(uid)
      Net::LDAP::Filter.eq('CN', uid) & employees
    end

    # Only query against the given uid as a member of the hifive ldap group
    # @param uid [String] the user id to check. e.g. 'drseuss'
    # @return [NET::LDAP::Filter] for employees query
    def self.hifive_admin(uid)
      library_staff_member(uid) & Net::LDAP::Filter.eq('memberof', ENV.fetch('APPS_H5_LDAP_GROUP'))
    end
  end
end
