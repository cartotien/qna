require 'rails_helper'

feature "Authenticated user can create answers", %q(
  In order to help other users or clarify question
  user can create answers
) do

  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given(:question) { create(:question, user: author) }

  describe "Authenticated user" do

    scenario "Tries to create answer" do
      sign_in(user)
      visit question_path(question)

      fill_in "Body", with: "MyText"
      click_on "Submit Answer"

      expect(page).to have_content("MyText")
    end
  end

  describe "Unauthenticated user" do
    scenario "Tries to create answer" do
      visit question_path(question)

      fill_in "Body", with: "MyText"
      click_on "Submit Answer"

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

end
