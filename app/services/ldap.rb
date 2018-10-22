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

  # Given a <something> determine whether a user is in the hifive admin group
  # @param uid [String] the user id to check. e.g. 'drseuss'
  # @return [String] the original uid, assuming it is in the hifive group
  def self.hifive_group(uid)
    result = ''

    ldap_connection.search(
      filter: hifive_filter(uid),
      attributes: %w[sAMAccountName],
      return_result: false
    ) { |item| result = item.sAMAccountName.first }

    validate_ldap_response
    result
  end

  # Only query against the given uid as a member of the hifive ldap group
  # @param uid [String] the user id to check. e.g. 'drseuss'
  # @return [NET::LDAP::Filter] for employees query
  def self.hifive_filter(uid)
    search_filter = Net::LDAP::Filter.eq('sAMAccountName', uid)
    category_filter = Net::LDAP::Filter.eq('objectcategory', 'user')
    member_filter = Net::LDAP::Filter.eq('memberof', Rails.application.credentials.ldap[:group])
    search_filter & category_filter & member_filter
  end

  # Used if an error is encountered for an ldap query. This could happen if LDAP is down, or a given user doesn't have a
  # manager in their record, etc.
  def self.validate_ldap_response
    msg = <<~MESSAGE
      Response Code: #{ldap_connection.get_operation_result.code}
      Message: #{ldap_connection.get_operation_result.message}
    MESSAGE
    raise msg unless ldap_connection.get_operation_result.code.zero?
  end

  # Query all currently active employees
  # @return [Array] employee information to populate Employees table
  def self.employees
    ldap_connection.search(
      filter: employees_filter,
      attributes: %w[DisplayName CN mail manager givenName sn]
    ) do |employee|
      Employee.populate_from_ldap(employee)
    end
    validate_ldap_response
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

  # Query manager email and name for a given employee
  # @param [String] dname information for the manager to lookup
  # @return [Hash] manager information with name and email keys
  # Example: { first_name: 'Dr.', last_name: 'Seuss', email: 'thedoctor@ucsd.edu' }
  # rubocop:disable Metrics/MethodLength
  def self.manager_details(dname)
    result = {}
    ldap_connection.search(
      base: dname,
      filter: Net::LDAP::Filter.eq('objectcategory', 'user'),
      attributes: %w[mail givenName sn]
    ) do |m|
      result[:email] = m.mail.first
      result[:first_name] = m.givenName.first
      result[:last_name] = m.sn.first
    end
    validate_ldap_response

    result
  end
  # rubocop:enable Metrics/MethodLength

  def self.manager_filter(uid)
    cname_filter = Net::LDAP::Filter.eq('CN', uid)
    category_filter = Net::LDAP::Filter.eq('objectcategory', 'user')
    cname_filter & category_filter
  end
end
