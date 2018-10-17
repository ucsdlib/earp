require 'rails_helper'

RSpec.describe 'adding a recognition', type: :system do
  before do
    omniauth_setup_shibboleth
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
    select('Select employee to recognize', from: 'recognition_recognizee')
    click_on('Create Recognition')
    expect(page).to have_selector('.new_recognition')
  end

  it 'allows a user to create a recognition', :aggregate_failures do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Joe Employee', from: 'recognition_recognizee')
    # check('recognition_anonymous')
    click_on('Create Recognition')
    visit recognitions_path
    expect(page).to have_content('Really Long Text...')
    expect(page).to have_content('collab')
    expect(page).to have_content('joe')
  end

  it 'allows an anonymous recognition' do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Joe Employee', from: 'recognition_recognizee')
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
    select('Jane Employee', from: 'recognition_recognizee')
    # check('recognition_anonymous')
    click_on('Create Recognition')

    click_on('Edit')
    fill_in('recognition_description', with: 'I changed my mind')
    select('Joe Employee', from: 'recognition_recognizee')
    click_on('Update Recognition')

    expect(page).to have_content('I changed my mind')
    expect(page).to have_content('collab')
    expect(page).to have_content('joe')
  end
end
