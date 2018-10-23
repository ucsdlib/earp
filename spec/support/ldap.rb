def mock_employee_query
  FactoryBot.create(:employee, display_name: 'Joe Employee')
  FactoryBot.create(:employee, display_name: 'Jane Employee')
  # allow(Ldap).to receive(:employees).and_return(
  #   [['Joe Employee', 'joe'],['Jane Employee', 'jane']]
  # )
end

# Mock out core ldap connection methods
# Critically: `ldap_connection` and `validate_ldap_response`
# It is expected that users of this will then mock queries/responses as needed for the context of the test(s)
def mock_ldap_connection
  fake_ldap_connection = double("MockLDAP")
  allow(Ldap).to receive(:ldap_connection).and_return(fake_ldap_connection)
  fake_ldap_connection
end

def mock_ldap_validation
  allow(Ldap).to receive(:validate_ldap_response).and_return(nil)
end

def mock_valid_library_employee
  # omniauth_test from #omniauth_setup_shibboleth
  allow(Ldap).to receive(:library_staff).and_return('omniauth_test')
end

def mock_invalid_library_employee
  allow(Ldap).to receive(:library_staff).and_return('')
end
