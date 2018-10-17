require 'rails_helper'

RSpec.describe 'authenticating', type: :system do
  context 'as a developer' do
    before do
      omniauth_setup_developer
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
