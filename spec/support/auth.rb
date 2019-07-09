def sign_in
  visit signin_path
end

def sign_out
  visit signout_path
end

def omniauth_setup_developer
  Rails.configuration.azureactivedirectory = false
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:azureactivedirectory] = OmniAuth::AuthHash.new({
    provider: 'developer',
    uid: '1',
    info: { 'email' => 'developer@ucsd.edu', 'name' => 'developer' }
  })
  Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:azureactivedirectory]
end

def omniauth_setup_azureactivedirectory
  Rails.configuration.azureactivedirectory = true
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:azureactivedirectory] = OmniAuth::AuthHash.new({
    provider: 'azureactivedirectory',
    uid: 'omniauth_test',
    info: { 'email' => 'test@ucsd.edu', 'name' => 'Dr. Seuss' }
  })
  Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:azureactivedirectory]
end
