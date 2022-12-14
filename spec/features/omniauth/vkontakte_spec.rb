require 'rails_helper'

feature 'User is able to log in through vkontakte', '
  User would like to be able to log in through vkontakte to speed up login process
' do
  describe 'Unregistered user' do
    background do
      visit new_user_session_path
      mock_auth('vkontakte', 'new@user.com')
      click_on 'Sign in with Vkontakte'
      open_email 'new@user.com'
      current_email.click_link('Confirm my account')
    end

    scenario 'tries to log in' do
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content('Successfully authenticated from Vkontakte account')
    end
  end

  describe 'Registered user' do
    given(:user) { create(:user, :confirmed_user) }

    scenario 'tries to log in' do
      visit new_user_session_path
      mock_auth('vkontakte', user.email)

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content('Successfully authenticated from Vkontakte account')
    end
  end
end
