require 'rails_helper'

RSpec.describe 'authenticating', type: :system do
  context 'as a user with no shibboleth credentials' do
    before do
      omniauth_setup_shibboleth
      OmniAuth.config.mock_auth[:shibboleth] = :invalid_credentials
      OmniAuth.config.on_failure = Proc.new { |env|
        OmniAuth::FailureEndpoint.new(env).redirect_to_failure
      }
    end

    it 'should not allow access to the application' do
      sign_in
      expect(page).to have_content('You are not an authorized Library employee')
    end

  end

  context 'as a developer' do
    before do
      omniauth_setup_developer
    end

    after(:all) do
      Rails.configuration.shibboleth = true
    end

    it 'enforces authentication' do
      sign_in
      expect(page).to have_content('Sign out')
    end

    it 'redirects to root url on sign out' do
      sign_in
      sign_out
      expect(page).to have_content('Sign in')
    end
  end

  context 'as a regular user with shibboleth' do
    before do
      omniauth_setup_shibboleth
    end

    it 'enforces authentication' do
      sign_in
      expect(page).to have_content('Sign out')
    end

    it 'redirects to root url on sign out' do
      sign_in
      sign_out
      expect(page).to have_content('Sign in')
    end
  end
end
