require 'rails_helper'

RSpec.describe OmniauthAuthenticationService do
  let(:user) { create(:user, :confirmed_user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: user.email }) }
  subject { User.find_for_oauth(auth) }

  context 'User has identity' do
    it 'returns the user' do
      user.identities.create(provider: 'github', uid: '123')
      expect(subject).to eq(user)
    end
  end

  context "User doesn't have an identity" do
    context 'user already exists' do
      it "doesn't create new user" do
        user
        expect { subject }.to_not change(User, :count)
      end

      it 'creates new identity' do
        expect { subject }.to change(user.identities, :count).by(1)
      end
    end

    context "user doesn't exist" do
      let(:auth) do
        OmniAuth::AuthHash.new(provider: 'github', uid: '123',
                               info: { email: 'newuser@mail.com', nickname: 'MyNick' })
      end
      let(:nicknameless_auth) do
        OmniAuth::AuthHash.new(provider: 'github', uid: '123',
                               info: { email: 'newuser@mail.com', nickname: '' })
      end

      it 'creates new user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'creates new identity' do
        expect(subject.identities).to_not be_empty
      end

      it 'fills email' do
        expect(subject.email).to eq(auth.info.email)
      end

      it 'fills nickname' do
        expect(subject.nickname).to eq(auth.info.nickname)
      end

      it 'uses email as a nickname when nickname is non-existent' do
        expect(User.find_for_oauth(nicknameless_auth).nickname).to eq('newuser')
      end

      it 'returns the new user' do
        expect(subject).to be_a(User)
      end
    end
  end

  it 'creates identity with provider and uid' do
    identity = subject.identities.last
    expect(identity.provider).to eq(auth.provider)
    expect(identity.uid).to eq(auth.uid)
  end
end
