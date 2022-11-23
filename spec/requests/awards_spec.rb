require 'rails_helper'

RSpec.describe 'Awards', type: :request do
  let(:question) { create :question, user: user }
  let(:user) { create(:user, :confirmed_user) }

  describe 'GET #index' do
    let!(:questions) { create_list :award, 3, user: user, question: question }

    before do
      sign_in(user)
      get awards_path
    end

    it 'populates an array of all questions' do
      expect(assigns(:awards)).to match_array(user.awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
