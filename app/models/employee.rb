# frozen_string_literal: true

# Employee - populated from LDAP bulk query
# Should never be edited locally
class Employee < ApplicationRecord
  has_many :recognitions, dependent: :destroy

  validates :uid, :email, :manager, :display_name, :name, presence: true

  # Given an Net::LDAP::Entry extract and populate an Employee record
  # using the cn/uid as the unique key
  # @param [Net::LDAP::Entry] employee_info
  def self.populate_from_ldap(employee_info)
    e = find_or_initialize_by(uid: employee_info.cn.first)
    e.display_name = employee_info.displayname.first
    e.email = employee_info.mail.first
    e.manager = employee_info.manager.first
    e.name = "#{employee_info.givenName.first} #{employee_info.sn.first}"
    e.save
  end
end
