def mock_email_credential
  fake_credentials = { sender: 'developer@ucsd.edu', bcc: 'user@ucsd.edu' }
  allow(Rails.application.credentials).to receive(:email).and_return(fake_credentials)
end

def mock_supervisor
  dn = 'CN=supervisor,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU'
  entry = Net::LDAP::Entry.new(dn)
  entry['sn'] = 'Seuss'
  entry['givenname'] = 'Dr.'
  entry['mail'] = 'supervisor@ucsd.edu'
  mock_ldap_validation
  allow(mock_ldap_connection).to receive(:search).and_yield(entry)
end