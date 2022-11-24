require 'rails_helper'

feature 'User can visit page with his awards' do
  given(:author) { create(:user, :confirmed_user) }
  given(:question) { create(:question, user: author) }
  given(:user) { create(:user, :confirmed_user) }
  given!(:awards) { create_list(:award, 3, question: question, user: user) }

  scenario 'User visits question page' do
    sign_in(user)
    visit awards_path

    expect(page).to have_content(awards[0].name)
    expect(page).to have_content(awards[1].name)
    expect(page).to have_content(awards[2].name)
  end
end
