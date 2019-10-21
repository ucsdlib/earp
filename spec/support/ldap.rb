def mock_employee_query
  FactoryBot.create(:employee, display_name: 'Employee, Joe')
  FactoryBot.create(:employee, display_name: 'Employee, Jane')
end

# Mock out core ldap connection methods
# Critically: `ldap_connection` and `validate_ldap_response`
# It is expected that users of this will then mock queries/responses as needed for the context of the test(s)
def mock_ldap_connection
  fake_ldap_connection = double("MockLDAP")
  allow(Ldap::Queries).to receive(:ldap_connection).and_return(fake_ldap_connection)
  fake_ldap_connection
end

def mock_ldap_validation
  allow(Ldap::Queries).to receive(:validate_ldap_response).and_return(nil)
end

def mock_valid_library_employee
  # omniauth_test from #omniauth_setup_google_oauth2
  allow(Ldap::Queries).to receive(:library_staff).and_return('omniauth_test')
end

def mock_invalid_library_employee
  allow(Ldap::Queries).to receive(:library_staff).and_return('')
end
