# frozen_string_literal: true

# RecognitionsHelper
module RecognitionsHelper
  def library_values
    LIBRARY_VALUES
  end

  # Query all currently active employees
  # @return [Array] employee information (Name, EmployeeID)
  def employees
    Ldap.employees
  end
end
