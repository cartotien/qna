require 'rails_helper'

RSpec.describe "Questions", type: :request do
  let(:question) { create :question, user: user }
  let(:valid_attributes) { { question: attributes_for(:question) } }
  let(:invalid_attributes) { { question: attributes_for(:question, :invalid) } }
  let(:user) { create(:user, :confirmed_user) }
  let(:false_user) { create(:user, :confirmed_user) }

  describe "GET #index" do
    let!(:questions) { create_list :question, 3, user: user }

    before { get questions_path }

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get question_path(question) }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq(question)
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before { sign_in(user) }
    before { get new_question_path }

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before { sign_in(user) }

    context "with valid attributes" do
      let(:valid_request) { post questions_path, params: valid_attributes }

      it "saves a new question in a database" do
        expect { valid_request }.to change(Question, :count).by(1)
      end

      it "redirects to show view" do
        valid_request

        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid attributes" do
      before { sign_in(user) }

      let!(:invalid_request) { post questions_path, params: invalid_attributes }

      it "doesn't save the question" do
        expect { invalid_request }.to_not change(Question, :count)
      end

      it "re-renders new view" do
        invalid_request

        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:question) { create :question, user: user }
    let(:http_request) { delete question_path(question) }

    context "Authenticated user is the author of question" do
      before { sign_in(user) }

      it "deletes the question of author" do
        expect { http_request }.to change(Question, :count).by(-1)
      end

      it "deletes the questions from user's question" do
        expect { http_request }.to change(user.questions, :count).by(-1)
      end
    end

    context "Autenticated user is not the author of question" do
      it "doesn't delete the question of another user" do
        sign_in(false_user)

        expect { http_request }.not_to change(Question, :count)
      end
    end

    it "redirects to index" do
      sign_in(user)

      delete question_path(question)

      expect(response).to redirect_to questions_path
    end
  end
end
