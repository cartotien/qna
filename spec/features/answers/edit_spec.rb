require 'rails_helper'

feature 'User is able to edit his answer', '
  In order to correct his mistakes or update the answer
  user would like to edit his answer
' do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Authenticated user', js: true do
    context 'Author' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'tries to update answer with valid params' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Body', with: 'Updated Answer'
          click_on 'Save'

          expect(page).not_to have_content(answer.body)
          expect(page).to have_content('Updated Answer')
        end
      end

      scenario 'tries to update answer with invalid params' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content(answer.body)
        end

        within '.answer-errors-update' do
          expect(page).to have_content("Body can't be blank")
        end
      end

      scenario 'tries to update answer with files attached' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Body', with: 'Updated Answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "tries to update another's answer" do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_content('Edit')
      end
    end
  end

  scenario 'Unauthenticated user tries to update the answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content('Edit')
    end
  end
end
