# frozen_string_literal: true

require 'net/ldap'

# Ldap provides a connection service to an LDAP server for queries
# Examples in this application are:
#   - Load all current library staff to populate a form <select> list
#   - Authorize an authenticated user to an LDAP group (admins)
class Ldap
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.ldap_connection
    @ldap_connection ||= Net::LDAP.new(
      host: Rails.application.credentials.ldap[:host],
      port: Rails.application.credentials.ldap[:port],
      base: Rails.application.credentials.ldap[:base],
      encryption: { method: :simple_tls },
      auth: {
        method: :simple,
        username: Rails.application.credentials.ldap[:username],
        password: Rails.application.credentials.ldap[:password]
      }
    )
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # Query all currently active employees
  # @return [Array] employee information (Name, EmployeeID)
  def self.employees
    result = []
    ldap_connection.search(
      filter: employees_filter,
      attributes: %w[DisplayName EmployeeID]
    ) do |employee|
      result << [employee.displayname.first, employee.employeeid.first]
    end
    result.sort
  end

  # Only show current library staff, excluding students
  # @return [NET::LDAP::Filter] for employees query
  def self.employees_filter
    employees_only = Net::LDAP::Filter.pres('EmployeeID')
    staff = Net::LDAP::Filter.eq('ObjectCategory', 'person')
    users = Net::LDAP::Filter.eq('ObjectClass', 'user')
    no_lib_accounts = Net::LDAP::Filter.ne('sAMAccountName', 'lib-*')
    employees_only & staff & users & no_lib_accounts
  end
end
