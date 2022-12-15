require 'rails_helper'

feature 'User is able to log in through github', '
  User would like to be able to log in through github to speed up login process
' do
  describe 'Unregistered user' do
    background do
      visit new_user_session_path
      mock_auth('github', 'new@user.com')
      click_on 'Sign in with GitHub'
      open_email 'new@user.com'
      current_email.click_link('Confirm my account')
    end

    scenario 'tries to log in' do
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from Github account')
    end
  end

  describe 'Registered user' do
    given(:user) { create(:user, :confirmed_user) }

    scenario 'tries to log in' do
      visit new_user_session_path
      mock_auth('github', user.email)

      click_on 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from Github account')
    end
  end
end
