def sign_in
  visit signin_path
end

def sign_out
  visit signout_path
end

def omniauth_setup_developer
  Rails.configuration.google_oauth2 = false
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'developer',
    uid: '1',
    info: { 'email' => 'developer@ucsd.edu', 'name' => 'developer' }
  })
  Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
end

def omniauth_setup_google_oauth2
  Rails.configuration.google_oauth2 = true
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: 'omniauth_test',
    info: { 'email' => 'test@ucsd.edu', 'name' => 'Dr. Seuss' }
  })
  Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
end
