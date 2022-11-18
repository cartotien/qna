require 'rails_helper'

feature "User is able to edit his question", %q(
  In order to correct his mistakes or clarify the question
  user would like to edit his question
) do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given!(:question) { create(:question, user: author) }

  scenario "Unauthenticated user tries to edit question" do
    visit question_path(question)

    expect(page).not_to have_link("Edit Question")
  end

  describe "Authenticated user" do
    describe "Author" do
      background do
        sign_in(author)
        visit question_path(question)
        click_on "Edit Question"
      end

      scenario "tries to edit his question", js: true do
        within 'form#edit-question' do
          fill_in "Body", with: 'Updated Question'
          click_on "Save"
        end

        within '.question' do
          expect(page).to_not have_content(question.body)
          expect(page).to have_content('Updated Question')
        end
      end

      scenario "tries to edit question with invalid params", js: true do
        within 'form#edit-question' do
          fill_in "Title", with: ''
          click_on "Save"
        end

        within '.question-errors' do
          expect(page).to have_content("Title can't be blank")
        end
      end
    end
    scenario "tries to edit another's question", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link("Edit Question")
    end
  end
end
