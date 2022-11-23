require 'rails_helper'

feature 'Authenticated user can create answers', '
  In order to help other users or clarify question
  user can create answers
' do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given(:question) { create(:question, user: author) }
  given(:gist_link) { 'https://gist.github.com/cartotien/09d41dc955dea1157744afdc08b77c03' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Tries to create answer', js: true do
      fill_in 'Body', with: 'MyText'
      click_on 'Submit Answer'

      within '.answers' do
        expect(page).to have_content('MyText')
      end
    end

    scenario 'Tries to create answer with invalid params', js: true do
      fill_in 'Body', with: ''
      click_on 'Submit Answer'

      within '.answer-errors-creation' do
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'Submits answer with file attached', js: true do
      fill_in 'Body', with: 'Answer Body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Submit Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Submits answer with links attached', js: true do
      within '.new-answer' do
        fill_in 'Body', with: 'Answer Body'
        click_on 'add link'
        fill_in 'Name', with: 'Link name'
        fill_in 'Url', with: gist_link
        click_on 'Submit Answer'
      end

      within '.answers' do
        expect(page).to have_link 'Link name'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Tries to create answer', js: true do
      visit question_path(question)

      expect(page).to_not have_field('Body')
    end
  end
end
