require 'rails_helper'

feature "Authenticated user can delete his answers" do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:answer2) { create(:answer, question: question, user: create(:user, :confirmed_user)) }

  scenario "Author tries to delete his answer", js: true do
    sign_in(author)

    visit question_path(question)

    within ".answers" do
      page.accept_confirm do
        click_link 'Delete'
      end

      expect(page).not_to have_content(answer.body)
    end
  end

  scenario "User tries to delete another's answer", js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content('Delete')
    end
  end

  scenario "Unuathenticated user tries to delete answer" do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content('Delete')
    end
  end
end
