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

  it "allows a user to create a recognition" do
    allow(RecognitionsController.helpers).to receive(:employees).and_return(
      [['Joe Employee', 'joe'],['Jane Employee']]
    )
    # TODO: replace w/ a helper + something like fabricator/faker
    visit signin_path

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    # select('Option', from: 'Employees')
    # check('recognition_anonymous')
    click_on("Create Recognition")
    visit recognitions_path
    expect(page).to have_content('Really Long Text...')
    expect(page).to have_content('collab')
  end

end
