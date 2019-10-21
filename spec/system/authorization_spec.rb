require 'rails_helper'

RSpec.describe 'enforcing authorization in recognitions', type: :system do
  before do
    mock_valid_library_employee
    omniauth_setup_google_oauth2
  end

  let!(:recognition_for_different_user) { FactoryBot.create(:recognition,
                                                user: user1,
                                                description: 'employee1 is great',
                                                employee: employee1) }
  let(:employee1) { FactoryBot.create(:employee) }
  let(:user1) { FactoryBot.create(:user) }
  let!(:recognition_for_logged_in_user) { FactoryBot.create(:recognition,
                                                user: logged_in_user,
                                                description: 'employee2 is great',
                                                employee: employee2) }
  let(:employee2) { FactoryBot.create(:employee) }
  # note omniauth_test is the uid set in omniauth_setup_google_oauth2
  # we need these to match for testing the 'logged in user'
  let(:logged_in_user) { FactoryBot.create(:user, uid: 'omniauth_test' ) }

  context 'as an administrator' do
    before do
      mock_library_administrator
    end

    it 'can see suppressed records' do
      suppressed_recognition = FactoryBot.create(:recognition,
                                                  user: user1,
                                                  suppressed: true,
                                                  description: 'i am suppressed',
                                                  employee: employee1)
      visit recognitions_path
      expect(page).to have_content('i am suppressed')
    end

    it 'can see links to edit/delete all records', :aggregate_failures do
      visit recognitions_path
      expect(page).to have_link('Edit', count: 2)
      expect(page).to have_link('Delete', count: 2)
    end

    it 'can edit a recognition they did not create', :aggregate_failures do
      visit edit_recognition_path(recognition_for_different_user)
      fill_in('recognition_description', with: 'admin approved')
      click_on('Edit the love')
      expect(page).to have_content('admin approved')
    end

    it 'can delete a recognition they did not create', js: true do
      visit recognitions_path

      accept_confirm do
        click_link('Delete', href: recognition_path(recognition_for_different_user))
      end
      expect(page.find(:css, "#flash_notice")).to have_content "Recognition was successfully destroyed."
    end
  end

  context 'as a library staff member' do
    before do
      mock_non_library_administrator
    end

    it 'cannot see suppressed records' do
      suppressed_recognition = FactoryBot.create(:recognition,
                                                  user: user1,
                                                  suppressed: true,
                                                  description: 'i am suppressed',
                                                  employee: employee1)
      visit recognitions_path
      expect(page).not_to have_content('i am suppressed')
    end

    it 'can only see links to edit/delete their own records', :aggregate_failures do
      visit recognitions_path
      expect(page).to have_link('Edit', count: 1)
      expect(page).to have_link('Edit', href: edit_recognition_path(recognition_for_logged_in_user))
      expect(page).to have_link('Delete', count: 1)
      expect(page).to have_link('Delete', href: recognition_path(recognition_for_logged_in_user))
    end

    it 'cannot edit a recognition they did not create', :aggregate_failures do
      visit edit_recognition_path(recognition_for_different_user)
      expect(page).to have_current_path(recognition_path(recognition_for_different_user))
      expect(page).to have_content('You are only allowed to modify your own recognitions')
    end
  end
end
