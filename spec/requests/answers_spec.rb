require 'rails_helper'

RSpec.describe 'Answers', type: :request do
  let(:user) { create(:user, :confirmed_user) }
  let(:false_user) { create(:user, :confirmed_user, nickname: 'test2') }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:valid_attributes) { { answer: { body: 'Answer' } } }
  let(:invalid_attributes) { { answer: attributes_for(:answer, :invalid_answer) } }

  describe 'GET #new' do
    before { get new_question_answer_path(question) }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      let(:valid_request) { post question_answers_path(question), xhr: true, params: valid_attributes }

      it 'saves the answer to database' do
        expect { valid_request }.to change(question.answers, :count).by(1)
      end

      it "saves the answer to user's answers" do
        expect { valid_request }.to change(user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_request) { post question_answers_path(question), xhr: true, params: invalid_attributes }

      it "doesn't save the answer" do
        expect { invalid_request }.to_not change(question.answers, :count)
      end
    end

    it 'renders create view' do
      sign_in(user)
      post question_answers_path(question), xhr: true, params: valid_attributes

      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:http_request) { delete answer_path(answer), xhr: true }

    context 'user is the author of the answer' do
      before { sign_in(user) }

      it 'destroys the answer' do
        expect { http_request }.to change(question.answers, :count).by(-1)
      end

      it "deletes the answer from user's answers" do
        expect { http_request }.to change(user.answers, :count).by(-1)
      end
    end

    context 'user is not the author of the answer' do
      before { sign_in(false_user) }

      it "doesn't destroy the answer" do
        expect { http_request }.not_to change(question.answers, :count)
      end
    end

    it 'renders destroy view' do
      sign_in(user)
      http_request

      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #mark_as_best' do
    let(:user) { create(:user, :confirmed_user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: false_user, question: question) }
    let(:answer2) { create(:answer, user: false_user, question: question, best: true) }
    let(:http_request) { patch mark_as_best_answer_path(answer), xhr: true }

    context 'author of question' do
      it 'marks the answer as best' do
        sign_in(user)
        http_request

        expect { answer.reload }.to change { answer.best }
      end

      it 'marks the answer as best even if another best answer exists' do
        answer2
        sign_in(user)
        http_request

        expect { answer.reload }.to change { answer.best }
        expect { answer2.reload }.to change { answer2.best }
      end
    end

    context 'non-author' do
      it "doesn't mark the answer as best" do
        sign_in(false_user)
        http_request

        expect { answer.reload }.not_to change { answer.best }
      end
    end

    it 'renders mark_as_best_view' do
      sign_in(user)
      http_request

      expect(response).to render_template :mark_as_best
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user, :confirmed_user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:valid_http_request) { patch answer_path(answer), xhr: true, params: valid_attributes }
    let(:invalid_http_request) { patch answer_path(answer), xhr: true, params: invalid_attributes }

    context 'author of the answer' do
      before do
        sign_in(user)
      end

      it 'updates the answer with valid params' do
        valid_http_request

        expect { answer.reload }.to change { answer.body }
      end

      it "doesn't update the answer with invalid params" do
        invalid_http_request

        expect { answer.reload }.not_to change { answer }
      end
    end

    context 'non-author of the answer' do
      it "doesn't update the answer" do
        sign_in(false_user)

        valid_http_request
        expect { answer.reload }.not_to change { answer }
      end
    end

    it 'renders update view' do
      sign_in(user)
      valid_http_request

      expect(response).to render_template :update
    end
  end
end
