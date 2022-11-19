class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
  end

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was created successfully.'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    else
      flash[:alert] = "You can't delete another's question."
    end
    redirect_to questions_path
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      flash[:notice] = 'Question was updated successfully.'
    else
      flash[:alert] = "You can't change another's question."
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
