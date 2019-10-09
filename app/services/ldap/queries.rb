# frozen_string_literal: true

module Ldap
  # A set of Ldap queries needed for the application
  class Queries
    # rubocop:disable Metrics/MethodLength
    def self.ldap_connection
      @ldap_connection ||= Net::LDAP.new(
        host: ENV.fetch('APPS_H5_LDAP_HOST'),
        port: ENV.fetch('APPS_H5_LDAP_PORT'),
        base: ENV.fetch('APPS_H5_LDAP_BASE'),
        encryption: { method: :simple_tls },
        auth: {
          method: :simple,
          username: ENV.fetch('APPS_H5_LDAP_USERNAME'),
          password: ENV.fetch('APPS_H5_LDAP_PW')
        }
      )
    end
    # rubocop:enable Metrics/MethodLength

    # Used if an error is encountered for an ldap query. This could happen if LDAP is down, or a given user doesn't have
    # a manager in their record, etc.
    def self.validate_ldap_response
      operation_result_code = ldap_connection.get_operation_result.code
      return nil if operation_result_code.zero?

      msg = <<~MESSAGE
        Response Code: #{Net::LDAP::ResultStrings[operation_result_code]}
        Message: #{ldap_connection.get_operation_result.message}
      MESSAGE

      Rails.logger.tagged('ldap') { Rails.logger.error msg }
      raise msg
    end

    # Query all currently active employees
    # rubocop:disable Metrics/MethodLength
    def self.employees
      Rails.logger.tagged('rake', 'employees') { Rails.logger.info 'Starting LDAP Employee load..' }
      current_employees = []
      ldap_connection.search(
        filter: Ldap::Filters.employees,
        return_result: false,
        attributes: %w[DisplayName CN mail manager givenName sn whenChanged]
      ) do |employee|
        Employee.populate_from_ldap(employee)
        current_employees << employee.cn.first
      end
      Employee.update_status_for_all(current_employees)
      validate_ldap_response
      Rails.logger.tagged('rake', 'employees') { Rails.logger.info 'Finished LDAP Employee load..' }
    end
    # rubocop:enable Metrics/MethodLength

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
