# frozen_string_literal: true

require 'ldap'

module ApplicationHelper
  # Community, Diversity, and Inclusion
  # Collaboration and Communication
  # Innovation, Creativity, and Risk-taking
  # Responsiveness, Flexibility, and Continuous Improvement
  # Service and Excellence
  def library_values
    [['Community, Diversity, and Inclusion', 'diversity'],
     ['Collaboration and Communication', 'collab'],
     ['Innovation, Creativity, and Risk-taking', 'innovate'],
     ['Responsiveness, Flexibility, and Continuous Improvement', 'flexible'],
     ['Service and Excellence', 'service']]
  end

  # Query all currently active employees
  # @return [Array] employee information (Name, EmployeeID)
  def employees
    result = []
    Ldap.new.ldap_connection.search(
      filter: employees_filter,
      attributes: %w[DisplayName EmployeeID]
    ) do |employee|
      result << [employee.displayname.first, employee.employeeid.first]
    end
    result
  end

  private

  # Only show current library staff, excluding students
  # @return [NET::LDAP::Filter] for employees query
  def employees_filter
    employees_only = Net::LDAP::Filter.pres('EmployeeID')
    staff = Net::LDAP::Filter.eq('ObjectCategory', 'person')
    users = Net::LDAP::Filter.eq('ObjectClass', 'user')
    no_lib_accounts = Net::LDAP::Filter.ne('sAMAccountName', 'lib-*')
    employees_only & staff & users & no_lib_accounts
  end
end
