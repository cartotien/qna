feature "User can visit question page", %q(
  In order to view the selected question
  to solve his problem
  user can visit question's page
) do

  given(:user) { create(:user, :confirmed_user) }
  given(:author) { create(:user, :confirmed_user) }
  given(:question) { create(:question, user: author) }

  scenario "User visits question page" do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  end
end
