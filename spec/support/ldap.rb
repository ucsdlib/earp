def mock_employee_query
  allow(Ldap).to receive(:employees).and_return(
    [['Joe Employee', 'joe'],['Jane Employee', 'jane']]
  )
end
