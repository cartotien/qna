require 'rails_helper'

RSpec.describe 'Link', type: :request do
  let(:user) { create(:user, :confirmed_user) }
  let(:false_user) { create(:user, :confirmed_user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      it "destroys user's own link" do
        sign_in(user)

        expect { delete link_path(link), xhr: true }.to change(question.links, :count)
      end

      it "doesn't destroy another's attachment" do
        sign_in(false_user)

        expect { delete link_path(link), xhr: true }.not_to change(question.links, :count)
      end

      it 'renders destroy view' do
        sign_in(user)
        delete link_path(link), xhr: true

        expect(response).to render_template :destroy
      end
    end

    context 'Unauthenticated user' do
      it "doesn't destroy another's attachment" do
        expect { delete link_path(link), xhr: true }.not_to change(question.links, :count)
      end
    end
  end
end
