require 'rails_helper'

RSpec.describe 'Attachments', type: :request do
  let(:user) { create(:user, :confirmed_user) }
  let(:false_user) { create(:user, :confirmed_user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, record: question, blob: blob) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      it "destroys user's own attachment" do
        sign_in(user)

        expect { delete attachment_path(attachment), xhr: true }.to change(question.files, :count)
      end

      it "doesn't destroy another's attachment" do
        sign_in(false_user)

        expect { delete attachment_path(attachment), xhr: true }.not_to change(question.files, :count)
      end

      it 'renders destroy view' do
        sign_in(user)
        delete attachment_path(attachment), xhr: true

        expect(response).to render_template :destroy
      end
    end

    context "Unauthenticated user" do
      it "doesn't destroy another's attachment" do
        expect { delete attachment_path(attachment), xhr: true }.not_to change(question.files, :count)
      end
    end
  end
end
