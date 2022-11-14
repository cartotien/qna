require 'rails_helper'

feature "User is able to delete answer" do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given!(:question) { create(:question, user: author) }

  scenario "User tries to delete his answer" do
    sign_in(author)

    visit questions_path

    expect(page).to have_content('Delete Question')
  end

  scenario "User tries to delete another's answer" do
    sign_in(user)

    visit questions_path

    expect(page).not_to have_content('Delete Question')
  end

  scenario "Unuathenticated user tries to delete answer" do
    visit questions_path

    expect(page).not_to have_content('Delete Question')
  end
end
