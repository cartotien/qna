require 'rails_helper'

feature 'Authenticated author of the resource can delete his attachments' do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Question', js: true do
    given!(:attachment) { create(:attachment, record: question, blob: blob) }

    context 'Authenticated user' do
      it 'tries to delete his own attachment' do
        sign_in(author)
        visit question_path(question)

        within '.question' do
          click_link 'X'

          expect(page).to_not have_content('rails_helper.rb')
        end
      end

      it "tries to delete another's attachment" do
        sign_in(user)
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_content('X')
        end
      end
    end

    context 'Unauthenticated user' do
      it 'tries to delete attachment' do
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_content('X')
        end
      end
    end
  end

  describe 'Answer', js: true do
    given!(:attachment) { create(:attachment, record: answer, blob: blob) }

    context 'Authenticated user' do
      it 'tries to delete his own attachment' do
        sign_in(author)
        visit question_path(question)

        within '.answers' do
          click_link 'X'

          expect(page).to_not have_content('rails_helper.rb')
        end
      end

      it "tries to delete another's attachment" do
        sign_in(user)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_content('X')
        end
      end
    end

    context 'Unauthenticated user' do
      it 'tries to delete attachment' do
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_content('X')
        end
      end
    end
  end
end
