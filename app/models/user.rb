# frozen_string_literal: true

require 'net/ldap'
require 'ldap'

# User - authenticated Library user
class User < ApplicationRecord
  has_many :recognitions, dependent: :destroy

  def self.find_or_create_for_developer(_access_token)
    User.find_by(uid: 1, provider: 'developer') ||
      User.create(uid: 1, provider: 'developer', email: 'developer@ucsd.edu', full_name: 'developer')
  end

  def self.find_or_create_for_shibboleth(access_token)
    begin
      uid = access_token['uid']
      email = access_token['info']['email'] || "#{uid}@ucsd.edu"
      provider = access_token['provider']
      name = access_token['info']['name']
    rescue StandardError => e
      logger.warn "shibboleth: #{e}"
    end
    User.find_by(uid: uid, provider: provider) ||
      User.create(uid: uid, provider: provider, email: email, full_name: name)
  end

  def self.in_super_user_group?(uid)
    lookup_group(uid) == uid
  end

  def self.lookup_group(search_param)
    result = ''
    ldap = Ldap.new

    ldap.ldap_connection.search(
      filter: group_filter(search_param),
      attributes: %w[sAMAccountName],
      return_result: false
    ) { |item| result = item.sAMAccountName.first }

    get_ldap_response(ldap)
    result
  end

  def self.group_filter(search_param)
    search_filter = Net::LDAP::Filter.eq('sAMAccountName', search_param)
    category_filter = Net::LDAP::Filter.eq('objectcategory', 'user')
    member_filter = Net::LDAP::Filter.eq('memberof', Rails.application.credentials.ldap[:group])
    search_filter & category_filter & member_filter
  end

  def self.get_ldap_response(ldap)
    msg = "Response Code: #{ldap.get_operation_result.code}, Message: #{ldap.get_operation_result.message}"

    raise msg unless ldap.get_operation_result.code.zero?
  end
end
