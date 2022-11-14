require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }

  subject { create(:user) }
  it { should validate_presence_of :nickname }
  it { should validate_uniqueness_of :nickname }

  describe "author_of_answer?" do
    let(:user) { create(:user) }
    let(:false_user) { create(:user, nickname: 'test2') }
    let(:question) { create(:question, user: user)}
    let(:answer) { create(:answer, user: user, question: question) }

    it "is expected user is the author of answer" do
      expect(user.author_of_answer?(answer)).to be true
    end

    it "is expected user isn't the author of answer" do
      expect(false_user.author_of_answer?(answer)).to be false
    end
  end
end
