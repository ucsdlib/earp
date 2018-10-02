# frozen_string_literal: true

require 'net/ldap'

# Ldap provides a connection service to an LDAP server for queries
# Examples in this application are:
#   - Load all current library staff to populate a form <select> list
#   - Authorize an authenticated user to an LDAP group (admins)
class Ldap
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def ldap_connection
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
end
