require 'rails_helper'

RSpec.describe "Answers", type: :request do
  let(:question) { create(:question) }
  let(:valid_attributes) { { answer: attributes_for(:answer) } }
  let(:invalid_attributes) { { answer: attributes_for(:answer, :invalid_answer) } }

  describe "GET #new" do
    before { get new_question_answer_path(question) }

    it "assigns a new question to @question" do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_request) { post question_answers_path(question), params: valid_attributes }

      it "saves the answer to database" do
        expect { valid_request }.to change(question.answers, :count).by(1)
      end

      it "redirects to answer's question" do
        valid_request

        expect(response).to redirect_to question
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
end
