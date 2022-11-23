require 'rails_helper'

feature 'Authenticated author of the resource can delete his links' do
  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Question', js: true do
    given!(:link) { create(:link, linkable: question) }

    context 'Authenticated user' do
      it 'tries to delete his own link' do
        sign_in(author)
        visit question_path(question)

        within '.question' do
          page.accept_confirm do
            click_link 'Delete'
          end

          expect(page).to_not have_content('gist')
        end
      end

      it "tries to delete another's link" do
        sign_in(user)
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_content('Delete')
        end
      end
    end

    context 'Unauthenticated user' do
      it 'tries to delete link' do
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_content('Delete')
        end
      end
    end
  end

  describe 'Answer', js: true do
    given!(:question) { create(:question, user: author) }
    given!(:link) { create(:link, linkable: answer) }

    context 'Authenticated user' do
      it 'tries to delete his own link' do
        sign_in(author)
        visit question_path(question)

        within 'li.attached-link' do
          page.accept_confirm do
            click_link 'Delete'
          end
        end

        expect(page).to_not have_content('gist')
      end

      it "tries to delete another's link" do
        sign_in(user)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_content('Delete')
        end
      end
    end

    context 'Unauthenticated user' do
      it 'tries to delete link' do
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_content('Delete')
        end
      end
    end
  end
end
