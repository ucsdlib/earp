def sign_in
  visit signin_path
end

def sign_out
  visit signout_path
end

def omniauth_setup_developer
  Rails.configuration.shibboleth = false
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:shibboleth] = OmniAuth::AuthHash.new({
    provider: 'developer',
    uid: '1',
    info: { 'email' => 'developer@ucsd.edu', 'name' => 'developer' }
  })
  Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:shibboleth]
end

def omniauth_setup_shibboleth
  Rails.configuration.shibboleth = true
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:shibboleth] = OmniAuth::AuthHash.new({
    provider: 'shibboleth',
    uid: '1',
    info: { 'email' => 'test@ucsd.edu', 'name' => 'Dr. Seuss' }
  })
  Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:shibboleth]
end
