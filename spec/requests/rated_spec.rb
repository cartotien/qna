require 'rails_helper'

RSpec.shared_examples 'Rated' do
  describe 'PATCH #uprate' do
    context 'Authenticated author' do
      it "shouldn't uprate" do
        sign_in(resource_author)

        patch polymorphic_path([:uprate, authored_resource])

        expect(response).to have_http_status(422)
      end
    end

    context 'Authenticated user' do
      it 'should uprate' do
        sign_in(user)

        patch polymorphic_path([:uprate, authored_resource])

        expect(response).to have_http_status(200)
      end
    end

    context 'Unauthenticated user' do
      it "shouldn't uprate due to redirect" do
        patch polymorphic_path([:uprate, authored_resource])

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'PATCH #downrate' do
    context 'Authenticated author' do
      it "shouldn't downrate" do
        sign_in(resource_author)

        patch polymorphic_path([:downrate, authored_resource])

        expect(response).to have_http_status(422)
      end
    end

    context 'Authenticated user' do
      it 'should downrate' do
        sign_in(user)

        patch polymorphic_path([:downrate, authored_resource])

        expect(response).to have_http_status(200)
      end
    end

    context 'Unauthenticated user' do
      it "shouldn't downrate due to redirect" do
        patch polymorphic_path([:downrate, authored_resource])

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE #cancel' do
    context 'Authenticated author' do
      it "shouldn't cancel" do
        sign_in(resource_author)

        delete polymorphic_path([:cancel, rated_resource])

        expect(response).to have_http_status(422)
      end
    end

    context 'Authenticated user' do
      it 'should cancel' do
        sign_in(user)

        delete polymorphic_path([:cancel, rated_resource])

        expect(response).to have_http_status(200)
      end
    end

    context 'Unauthenticated user' do
      it "shouldn't cancel due to redirect" do
        delete polymorphic_path([:cancel, authored_resource])

        expect(response).to have_http_status(302)
      end
    end
  end
end

RSpec.describe 'Questions', type: :request do
  let(:rate) { create(:rate, user: user, value: 1, rateable: rated_resource) }
  let(:rated_resource) { create(:question, user: resource_author) }
  let(:authored_resource) { create :question, user: resource_author }
  let(:resource_author) { create(:user, :confirmed_user) }
  let(:user) { create(:user, :confirmed_user) }

  include_examples 'Rated'
end

RSpec.describe 'Answers', type: :request do
  let(:question) { create :question, user: resource_author }
  let(:rate) { create(:rate, user: user, value: 1, rateable: rated_resource) }
  let(:rated_resource) { create(:answer, user: resource_author, question: question) }
  let(:authored_resource) { create :answer, user: resource_author, question: question }
  let(:resource_author) { create(:user, :confirmed_user) }
  let(:user) { create(:user, :confirmed_user) }

  include_examples 'Rated'
end
