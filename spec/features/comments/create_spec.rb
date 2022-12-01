require 'rails_helper'

feature 'Authenticated user can create comments', '
  In order to clarify question or answer
  user can create comments
' do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'valid params' do
      scenario 'tries to create comment for question' do
        within '.question' do
          fill_in 'Content', with: 'Comment Content'
          click_on 'Submit Comment'
        end

        expect(page).to have_content 'Comment Content'
      end

      scenario 'tries to create comment for answer' do
        within '.answer' do
          fill_in 'Content', with: 'Comment Content'
          click_on 'Submit Comment'
        end

        expect(page).to have_content 'Comment Content'
      end
    end

    context 'invalid params' do
      scenario 'tries to create comment for question' do
        within '.question' do
          fill_in 'Content', with: ''
          click_on 'Submit Comment'
        end

        expect(page).to have_content "Content can't be blank"
      end

      scenario 'tries to create comment for answer' do
        within '.answer' do
          fill_in 'Content', with: ''
          click_on 'Submit Comment'
        end

        expect(page).to have_content "Content can't be blank"
      end
    end
  end

  context 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Content', with: 'Comment Content'
          click_on 'Submit Comment'
        end

        expect(page).to have_content('Comment Content')
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('Comment Content')
      end
    end
  end
end
