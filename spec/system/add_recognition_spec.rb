require 'rails_helper'

RSpec.describe "adding a recognition", type: :system do
  it "enforces authentication" do
    visit new_recognition_path
    expect(page).to have_content("Sign out")
  end

  # TODO: the recognizee will have to be stubbed. This will never work on CircleCI with a live LDAP query. Cache?
  it "allows a user to create a recognition" do
    visit new_recognition_path
    fill_in('description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'Library Values')
    select('Option', from: 'Employees')
    check('A Checkbox')
    click_on("Submit")
    visit recogntions_path
    expect(page).to have_content('Really Long Text...')
  end

end
