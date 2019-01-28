# frozen_string_literal: true

# Employee - populated from LDAP bulk query
# Should never be edited locally
class Employee < ApplicationRecord
  has_many :recognitions, dependent: :destroy

  validates :uid, :email, :manager, :display_name, :name, presence: true

  # custom scopes
  scope :sort_by_name, -> { order(:display_name) }
  scope :active_employees, -> { where(active: true).sort_by_name }

  # Given an Net::LDAP::Entry extract and populate an Employee record
  # using the cn/uid as the unique key
  # @param [Net::LDAP::Entry] employee_info
  def self.populate_from_ldap(employee_info)
    e = find_or_initialize_by(uid: employee_info.cn.first)
    return unless needs_update?(e, String(employee_info.whenChanged.first))

    update_employee_from_ldap(e, employee_info)
  end

  # Update a new, or existing, Employee with the employee info from LDAP
  def self.update_employee_from_ldap(employee, employee_info)
    Rails.logger.tagged('employee', 'update') { Rails.logger.info "updating employee: #{employee.uid}" }
    employee.display_name = employee_info.displayname.first
    employee.email = employee_info.mail.first
    employee.manager = manager_cn_from_dn(employee_info.manager.first) if employee_info.respond_to?(:manager)
    employee.name = employee_display_name(employee_info)
    employee.save
  end

  # Given an Net::LDAP::Entry extract and populate an Employee record
  # using the cn/uid as the unique key
  # @param [Net::LDAP::Entry] employee_info
  def self.employee_display_name(employee_info)
    "#{employee_info.givenName.first} #{employee_info.sn.first}"
  end

  # Extract the CN/UID for a manager from their full DN
  # @param [String] manager_dn
  # Example: CN=bigboss1,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU
  def self.manager_cn_from_dn(manager_dn)
    manager_dn.split(',').first.gsub('CN=', '')
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

  # Takes a current listing of employees from the Ldap::Queries.employees query and compares it to the listing in the
  # Employee database. If there are employees in database that are NOT in the ldap response, we need to mark them
  # inactive under the assumption they no longer work for the library
  # @param [Array] employees where each entry is the uid of a given employee
  def self.update_status_for_all(employees)
    (Employee.active_employees.pluck(:uid) - employees).each do |employee_uid|
      Rails.logger.tagged('employee', 'deactivate') { Rails.logger.error "deactivating employee: #{employee_uid}" }
      employee_to_deactivate = Employee.find_by(uid: employee_uid)
      employee_to_deactivate.active = false
      employee_to_deactivate.save
    end
  end
end
