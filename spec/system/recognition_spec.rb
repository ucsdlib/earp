require 'rails_helper'

RSpec.describe 'interacting with recognitions', type: :system do
  before do
    mock_valid_library_employee
    omniauth_setup_shibboleth
    mock_email_credential
  end

  it 'enforces authentication' do
    visit new_recognition_path
    expect(page).to have_content('Sign out')
  end

  it 'does not allow a user to create a recognition without a recognizee, value, and description' do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: '')
    select('Select library value', from: 'recognition_library_value')
    select('Select employee to recognize', from: 'recognition_employee_id')
    click_on('Create Recognition')
    expect(page).to have_selector('.new_recognition')
  end

  it 'allows a user to create a recognition', :aggregate_failures do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Joe Employee', from: 'recognition_employee_id')
    # check('recognition_anonymous')
    click_on('Create Recognition')
    visit recognitions_path
    expect(page).to have_content('Really Long Text...')
    expect(page).to have_content('Collaboration and Communication')
    expect(page).to have_content('Joe Employee')
  end

  it 'allows an anonymous recognition' do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Joe Employee', from: 'recognition_employee_id')
    check('recognition_anonymous')
    click_on('Create Recognition')
    visit recognitions_path
    expect(page).to have_content('Anonymous')
  end

  it "allows a user to edit an existing recognition", :aggregate_failures do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Jane Employee', from: 'recognition_employee_id')
    # check('recognition_anonymous')
    click_on('Create Recognition')

    click_on('Edit')
    fill_in('recognition_description', with: 'I changed my mind')
    select('Joe Employee', from: 'recognition_employee_id')
    click_on('Update Recognition')

    expect(page).to have_content('I changed my mind')
    expect(page).to have_content('Collaboration and Communication')
    expect(page).to have_content('Joe Employee')
  end

  it 'does not allow a user to edit a recognition without a recognizee, value, or description', :aggregate_failures do
    sign_in
    mock_employee_query
    # create recognition
    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Jane Employee', from: 'recognition_employee_id')
    click_on('Create Recognition')
    # try editing it creating an invalid entry
    click_on('Edit')
    fill_in('recognition_description', with: '')
    click_on('Update Recognition')
    # assert we're back on the edit page with original context
    expect(page).to have_selector('.edit_recognition')
  end

  it 'allows a user to delete their own recognitions', js: true do
    sign_in
    mock_employee_query
    # create recognition
    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Jane Employee', from: 'recognition_employee_id')
    click_on('Create Recognition')
    # try editing it creating an invalid entry
    visit recognitions_path
    accept_confirm do
      click_on('Destroy')
    end
    expect(page.find(:css, "#notice")).to have_content "Recognition was successfully destroyed."
  end

end
