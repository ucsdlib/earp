require 'rails_helper'

RSpec.describe '[Interacting with Recognitions]', type: :system do
  before do
    mock_valid_library_employee
    omniauth_setup_azureactivedirectory
    mock_email_credential
    mock_non_library_administrator
  end

  it 'enforces authentication' do
    visit new_recognition_path
    expect(page).to have_content('You have successfully authenticated')
  end

  it 'redirects after authentication to originally requested path' do
    visit recognitions_path
    expect(page).to have_current_path(recognitions_path)
  end

  it 'does not display inactive employees in the select list' do
    sign_in
    FactoryBot.create(:employee, display_name: 'Lincoln, Abraham')
    FactoryBot.create(:employee, active: false, display_name: 'Washington, George')
    FactoryBot.create(:employee, display_name: 'Adams, John')
    visit new_recognition_path
    expect(page.find_field('recognition_employee_id').text).to eq "Select one… Adams, John Lincoln, Abraham"

  end

  it 'sorts the employees by display name in the select list' do
    sign_in
    FactoryBot.create(:employee, display_name: 'Lincoln, Abraham')
    FactoryBot.create(:employee, display_name: 'Washington, George')
    FactoryBot.create(:employee, display_name: 'Adams, John')
    visit new_recognition_path
    expect(page.find_field('recognition_employee_id').text).to eq "Select one… Adams, John Lincoln, Abraham Washington, George"
  end

  it 'does not allow a user to create a recognition without a recognizee, value, and description' do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: '')
    select('Select one…', from: 'recognition_library_value')
    select('Select one…', from: 'recognition_employee_id')
    click_on('Share the love')
    expect(page).to have_selector('.new_recognition')
  end

  it 'allows a user to create a recognition', :aggregate_failures do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Employee, Joe', from: 'recognition_employee_id')
    # check('recognition_anonymous')
    click_on('Share the love')
    visit recognitions_path
    expect(page).to have_content('Really Long Text...')
    expect(page).to have_content('Collaboration and Communication')
    expect(page).to have_content('Employee, Joe')
  end

  it 'allows an anonymous recognition' do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Employee, Joe', from: 'recognition_employee_id')
    check('recognition_anonymous')
    click_on('Share the love')
    visit recognitions_path
    expect(page).to have_content('Anonymous')
  end

  it "allows a user to edit an existing recognition", :aggregate_failures do
    sign_in
    mock_employee_query

    visit new_recognition_path
    fill_in('recognition_description', with: 'Really Long Text...')
    select('Collaboration and Communication', from: 'recognition_library_value')
    select('Employee, Jane', from: 'recognition_employee_id')
    # check('recognition_anonymous')
    click_on('Share the love')

    click_on('Edit Recognition')
    fill_in('recognition_description', with: 'I changed my mind')
    select('Employee, Joe', from: 'recognition_employee_id')
    click_on('Edit the love')

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
    select('Employee, Jane', from: 'recognition_employee_id')
    click_on('Share the love')
    # try editing it creating an invalid entry
    click_on('Edit Recognition')
    fill_in('recognition_description', with: '')
    click_on('Edit the love')
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
    select('Employee, Jane', from: 'recognition_employee_id')
    click_on('Share the love')
    # try editing it creating an invalid entry
    visit recognitions_path
    accept_confirm do
      click_on('Delete')
    end
    expect(page.find(:css, '#flash_notice')).to have_content 'Recognition was successfully destroyed.'
  end

end
