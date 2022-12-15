require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many(:identities).dependent(:destroy) }

  subject { create(:user) }
  it { should validate_presence_of :nickname }
  it { should validate_uniqueness_of :nickname }

  describe 'author_of?' do
    let(:user) { create(:user) }
    let(:false_user) { create(:user, nickname: 'test2') }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it 'is expected user is the author of resource' do
      expect(user.author_of?(answer)).to be true
      expect(user.author_of?(question)).to be true
    end

    it "is expected user isn't the author of resource" do
      expect(false_user.author_of?(answer)).to be false
      expect(false_user.author_of?(question)).to be false
    end
  end

  describe 'find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double 'OmniauthAuthenticationService' }

    it 'calls OmniauthAuthenticationService' do
      expect(OmniauthAuthenticationService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
