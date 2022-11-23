require 'rails_helper'

feature 'User is able to edit his question', '
  In order to correct his mistakes or clarify the question
  user would like to edit his question
' do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given!(:question) { create(:question, user: author) }
  given(:gist_link) { 'https://gist.github.com/cartotien/09d41dc955dea1157744afdc08b77c03' }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).not_to have_link('Edit Question')
  end

  describe 'Authenticated user' do
    describe 'Author' do
      background do
        sign_in(author)
        visit question_path(question)
        click_on 'Edit Question'
      end

      scenario 'tries to edit his question', js: true do
        within 'form#edit-question' do
          fill_in 'Body', with: 'Updated Question'
          click_on 'Save'
        end

        within '.question' do
          expect(page).to_not have_content(question.body)
          expect(page).to have_content('Updated Question')
        end
      end

      scenario 'tries to edit question with invalid params', js: true do
        within 'form#edit-question' do
          fill_in 'Title', with: ''
          click_on 'Save'
        end

        within '.question-errors' do
          expect(page).to have_content("Title can't be blank")
        end
      end

      scenario 'tries to edit question with file attached', js: true do
        within 'form#edit-question' do
          fill_in 'Title', with: 'Question Title'
          fill_in 'Body', with: 'Question Body'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'tries to edit question with link attached', js: true do
        within 'form#edit-question' do
          fill_in 'Title', with: 'Question Title'
          fill_in 'Body', with: 'Question Body'
          click_on 'add link'

          within '.attachable-links' do
            fill_in 'Name', with: 'Link Name'
            fill_in 'Url', with: gist_link
          end
          click_on 'Save'
        end

        expect(page).to have_link 'Link Name'
      end
    end

    scenario "tries to edit another's question", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link('Edit Question')
    end
  end
end
