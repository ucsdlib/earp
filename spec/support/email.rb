def mock_email_credential
  fake_credentials = { sender: 'developer@ucsd.edu', bcc: 'user@ucsd.edu' }
  allow(Rails.application.credentials).to receive(:email).and_return(fake_credentials)
end
