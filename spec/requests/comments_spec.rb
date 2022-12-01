require 'rails_helper'

RSpec.shared_examples 'Commented' do
  let(:invalid_params) { { comment: { content: '' } } }
  let(:invalid_request) { post polymorphic_path([resource, :comments]), params: invalid_params, xhr: true }
  let(:valid_params) { { comment: { content: 'Comment Content' } } }
  let(:valid_request) { post polymorphic_path([resource, :comments]), params: valid_params, xhr: true }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it "status' should be 200" do
        valid_request

        expect(response).to have_http_status(200)
      end

      context 'valid params' do
        it "should change resource's comments amount by 1" do
          expect { valid_request }.to change(resource.comments, :count).by(1)
        end
      end

      context 'invalid params' do
        it "shouldn't change resource's comments amount" do
          expect { invalid_request }.not_to change(resource.comments, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      it "status' should be 401" do
        valid_request

        expect(response).to have_http_status(401)
      end

      it "shouldn't change resource's comments amount" do
        expect { valid_request }.not_to change(resource.comments, :count)
      end
    end
  end
end

RSpec.describe 'Questions', type: :request do
  let(:resource) { create :question, user: user }
  let(:user) { create(:user, :confirmed_user) }

  include_examples 'Commented'
end

RSpec.describe 'Answers', type: :request do
  let(:question) { create :question, user: user }
  let(:resource) { create :answer, user: user, question: question }
  let(:user) { create(:user, :confirmed_user) }

  include_examples 'Commented'
end
