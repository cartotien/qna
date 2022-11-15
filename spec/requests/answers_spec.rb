require 'rails_helper'

RSpec.describe "Answers", type: :request do
  let(:user) { create(:user, :confirmed_user) }
  let(:false_user) { create(:user, :confirmed_user, nickname: 'test2') }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:valid_attributes) { { answer: { body: 'Answer', user_id: user } } }
  let(:invalid_attributes) { { answer: attributes_for(:answer, :invalid_answer) } }

  describe "GET #new" do
    before { get new_question_answer_path(question) }

    it "assigns a new answer to @answer" do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before { sign_in(user) }

    context "with valid attributes" do
      let(:valid_request) { post question_answers_path(question), params: valid_attributes }

      it "saves the answer to database" do
        expect { valid_request }.to change(question.answers, :count).by(1)
      end

      it "redirects to answer's question" do
        valid_request

        expect(response).to redirect_to question
      end

      it "saves the answer to user's answers" do
        expect { valid_request }.to change(user.answers, :count).by(1)
      end
    end

    context "with invalid attributes" do
      let(:invalid_request) { post question_answers_path(question), params: invalid_attributes }

      it "doesn't save the answer" do
        expect { invalid_request }.to_not change(question.answers, :count)
      end

      it "re-renders new view" do
        invalid_request

        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:http_request) { delete answer_path(answer) }

    context "user is the author of the answer" do
      before { sign_in(user) }

      it "destroys the answer" do
        expect { http_request }.to change(question.answers, :count).by(-1)
      end

      it "deletes the answer from user's answers" do
        expect { http_request }.to change(user.answers, :count).by(-1)
      end
    end

    context "user is not the author of the answer" do
      before { sign_in(false_user) }

      it "doesn't destroy the answer" do
        expect { http_request }.not_to change(question.answers, :count)
      end
    end

    it "redirects to answer's parent question" do
      sign_in(user)

      expect(http_request).to redirect_to answer.question
    end
  end
end
