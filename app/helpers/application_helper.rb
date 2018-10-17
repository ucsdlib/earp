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
    Ldap.employees
  end
end
