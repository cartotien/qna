require 'rails_helper'

feature "User is able to delete question" do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given!(:question) { create(:question, user: author) }

  scenario "User tries to delete his question" do
    sign_in(author)

    visit question_path(question)

    expect(page).to have_content('Delete Question')
  end

  scenario "User tries to delete another's question" do
    sign_in(user)

    visit question_path(question)

    expect(page).not_to have_content('Delete Question')
  end

  scenario "Unuathenticated user tries to delete question" do
    visit question_path(question)

    expect(page).not_to have_content('Delete Question')
  end
end
