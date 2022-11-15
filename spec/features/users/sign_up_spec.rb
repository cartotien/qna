require 'rails_helper'

feature 'User can sign up', %q(
  User would like to Sign Up
  to be an authenticated user
  in order to ask questions
) do
  scenario 'User tries to register' do
    visit new_user_registration_path

    fill_in 'Email', with: 'MyEmail@email.com'
    fill_in 'Nickname', with: 'test'
    fill_in 'Password', with: 'MyPassword'
    fill_in 'Password confirmation', with: 'MyPassword'
    click_on 'Sign up'

    expect(page).to have_content "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
  end
end
