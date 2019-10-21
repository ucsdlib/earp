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

  # Finds or creates a google oauth2 account
  # @param access_token [OmniAuth::AuthHash]
  def self.find_or_create_for_google_oauth2(access_token)
    begin
      email = access_token.info.email || "#{uid}@ucsd.edu"
      uid = employee_uid(email, access_token.uid)
      provider = access_token.provider
      name = access_token.info.name
    rescue StandardError => e
      logger.tagged('google_oauth2') { logger.error e } && return
    end
    User.find_by(uid: uid) ||
      User.create(uid: uid, provider: provider, email: email, full_name: name)
  end

  def self.employee_uid(user_email, uid)
    uid unless numeric?(uid)
    employee = Employee.find_by("lower(email) = '#{user_email.to_s.downcase}'")
    return employee.uid.downcase if employee

    uid
  end

  def self.numeric?(uid)
    true if Integer(uid)
  rescue StandardError
    false
  end

  def self.administrator?(uid)
    Ldap::Queries.hifive_group(uid) == uid
  end

  def developer?
    provider.eql?('developer')
  end

  # Determine whether the authenticated Shib user is Library staff
  # @param uid [String] example: 'drseuss'
  # @return [Boolean]
  def self.library_staff?(uid)
    Ldap::Queries.library_staff(uid) == uid
  end
end
