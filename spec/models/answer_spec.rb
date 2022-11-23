require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  describe 'mark_as_best' do
    let(:user) { create(:user, :confirmed_user) }
    let(:question) { create(:question, user: user) }
    let(:award) { create(:award, question: question) }
    let(:answers) { create_list(:answer, 4, question: question, user: user) }
    let(:best_answer) { create(:answer, question: question, user: user, best: true) }

    it 'should mark answer as best' do
      expect { answers[0].mark_as_best }.to change(answers[0], :best)
    end

    it 'should mark the answer as best even if the other answer is best' do
      best_answer

      expect { answers[0].mark_as_best }.to change(answers[0], :best)
      expect { best_answer.reload }.to change(best_answer, :best)
    end

    it 'should give user an award' do
      question
      award
      
      expect { answers[0].mark_as_best }.to change(answers[0].question.award, :user)
    end
  end

  it 'has many files attached' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
