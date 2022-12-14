require 'rails_helper'

RSpec.describe 'Omniauth_callbacks', type: :request do
  let(:user) { create(:user, :confirmed_user, email: 'test@mail.com') }

  describe '#github' do
    before { Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] }

    context 'when user exists' do
      before(:each) do
        Rails.application.env_config['omniauth.auth'] = mock_auth('github', user.email)
      end

      it "doesn't create a new user" do
        expect { get user_github_omniauth_callback_path }.to_not change(User, :count)
      end

      it 'redirects to root' do
        get user_github_omniauth_callback_path

        expect(response).to redirect_to root_path
      end
    end

    context "when user doesn't exist" do
      before(:each) do
        Rails.application.env_config['omniauth.auth'] = mock_auth('github', 'test1@mail.com')
      end

      it 'creates new user' do
        expect { get user_github_omniauth_callback_path }.to change(User, :count).by(1)
      end

      it 'redirects to sign in' do
        get user_github_omniauth_callback_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#vkontakte' do
    before { Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] }

    context 'when user exists' do
      before(:each) do
        Rails.application.env_config['omniauth.auth'] = mock_auth('vkontakte', user.email)
      end

      it "doesn't create a new user" do
        expect { get user_vkontakte_omniauth_callback_path }.to_not change(User, :count)
      end

      it 'redirects to root' do
        get user_vkontakte_omniauth_callback_path

        expect(response).to redirect_to root_path
      end
    end

    context "when user doesn't exist" do
      before(:each) do
        Rails.application.env_config['omniauth.auth'] = mock_auth('vkontakte', 'test1@mail.com')
      end

      it 'creates new user' do
        expect { get user_vkontakte_omniauth_callback_path }.to change(User, :count).by(1)
      end

      it 'redirects to sign in' do
        get user_vkontakte_omniauth_callback_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
