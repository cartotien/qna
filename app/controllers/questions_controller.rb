class QuestionsController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: %i[show index]
  before_action :set_question, only: %i[show edit update destroy]

  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    gon.question_id = @question.id
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
  end

  def new
    @question = current_user.questions.build
    @question.build_award
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

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions_channel',
                                 html:
                                  ApplicationController.render(
                                    partial: 'questions/question_index',
                                    locals: { question: @question }
                                  ),
                                 author_id: current_user.id)
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url _destroy],
                                                    award_attributes: %i[name link _destroy])
  end
end
