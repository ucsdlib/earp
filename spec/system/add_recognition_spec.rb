require 'rails_helper'

RSpec.describe "adding a recognition", type: :system do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:shibboleth] = OmniAuth::AuthHash.new({
      provider: 'shibboleth',
      uid: '1',
      info: { 'email' => 'test@ucsd.edu', 'name' => 'Dr. Seuss' }
    })
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:shibboleth]
  end

  it "enforces authentication" do
    visit new_recognition_path
    expect(page).to have_content("Sign out")
  end

  it "allows a user to create a recognition", :aggregate_failures do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Joe Employee', from: 'recognition_recognizee')
    # check('recognition_anonymous')
    click_on("Create Recognition")
    visit recognitions_path
    expect(page).to have_content('Really Long Text...')
    expect(page).to have_content('collab')
    expect(page).to have_content('joe')
  end

  it "allows a user to edit an existing recognition", :aggregate_failures do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Jane Employee', from: 'recognition_recognizee')
    # check('recognition_anonymous')
    click_on("Create Recognition")

    click_on("Edit")
    fill_in('recognition_description', with: 'I changed my mind')
    select('Joe Employee', from: 'recognition_recognizee')
    click_on("Update Recognition")

    expect(page).to have_content('I changed my mind')
    expect(page).to have_content('collab')
    expect(page).to have_content('joe')
  end
end
