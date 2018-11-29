# frozen_string_literal: true

module Ldap
  # A set of Ldap queries needed for the application
  class Queries
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

    # Used if an error is encountered for an ldap query. This could happen if LDAP is down, or a given user doesn't have
    # a manager in their record, etc.
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
        filter: Ldap::Filters.employees,
        return_result: false,
        attributes: %w[DisplayName CN mail manager givenName sn whenChanged]
      ) do |employee|
        Employee.populate_from_ldap(employee)
      end
      validate_ldap_response
    end

    # Given a UID/CN determine whether a user is a library staff member using #employees filter
    # @param uid [String] the user id to check. e.g. 'drseuss'
    # @return [String] the original uid if valid library staff
    def self.library_staff(uid)
      result = ''

      ldap_connection.search(
        filter: Ldap::Filters.library_staff_member(uid),
        attributes: %w[CN],
        return_result: false
      ) { |item| result = item.cn.first }

      validate_ldap_response
      result
    end

    # Given a UID/CN determine whether a user is in the hifive admin group
    # @param uid [String] the user id to check. e.g. 'drseuss'
    # @return [String] the original uid, assuming it is in the hifive group
    def self.hifive_group(uid)
      result = ''

      ldap_connection.search(
        filter: Ldap::Filters.hifive_admin(uid),
        attributes: %w[CN],
        return_result: false
      ) { |item| result = item.cn.first }

      validate_ldap_response
      result
    end
  end
end
