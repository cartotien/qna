feature "User can visit page with questions", %q(
  In order to select the most relevant question
  to solve his problem
  user can visit page with all questions
) do

  given(:user) { create(:user, :confirmed_user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario "User visits index page" do
    visit questions_path

    expect(page).to have_content(questions[0].title)
    expect(page).to have_content(questions[1].title)
    expect(page).to have_content(questions[2].title)
  end
end
