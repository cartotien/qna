require 'rails_helper'

feature "Authenticated user can delete his answers" do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario "Author tries to delete his answer" do
    sign_in(author)

    visit question_path(question)
    click_on 'Delete'

    expect(page).not_to have_content(answer.body)
  end

  scenario "User tries to delete another's answer" do
    sign_in(user)

    visit question_path(question)

    expect(page).not_to have_content('Delete')
  end

  scenario "Unuathenticated user tries to delete answer" do
    visit question_path(question)

    expect(page).not_to have_content('Delete')
  end
end
