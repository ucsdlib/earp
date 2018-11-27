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
    return unless needs_update?(e, String(employee_info.whenChanged.first))

    update_employee_from_ldap(e, employee_info)
  end

  # Given an Net::LDAP::Entry store the employee photo if available
  # @param [Net::LDAP::Entry] employee_info
  def self.cache_employee_photo(employee_info)
    return unless employee_info.respond_to?(:thumbnailphoto)

    image_path = Rails.root.join('app', 'assets', 'images', 'photos', "#{employee_info.cn.first}.jpg")
    IO.write(image_path.to_s, employee_info.thumbnailphoto.first, mode: 'wb')
  end

  # Update a new, or existing, Employee with the employee info from LDAP
  def self.update_employee_from_ldap(employee, employee_info)
    employee.display_name = employee_info.displayname.first
    employee.email = employee_info.mail.first
    employee.manager = employee_info.manager.first
    employee.name = "#{employee_info.givenName.first} #{employee_info.sn.first}"
    employee.save
    # try saving thumbnail as well
    cache_employee_photo(employee_info)
  end

  # If an employee already exists in our local database,
  # and the local database modified time is younger then the ldap modified time,
  # then we can skip updating that record.
  # @param [Employee] current employee to check for update needs
  # @param [String] last updated date from ldap. Example. "20181127172427.0Z"
  def self.needs_update?(employee, ldap_last_updated)
    return true unless employee.id # new records get updates always
    return true if Time.zone.parse(ldap_last_updated) > employee.updated_at

    false
  end
end
