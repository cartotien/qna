class AnswersController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: :new
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[update destroy mark_as_best]

  after_action :publish_answer, only: :create

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    flash[:notice] = 'Answer was created successfully.'
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was deleted successfully.'
    else
      flash[:notice] = "You can't delete another's answer."
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:notice] = 'Answer was updated successfully.'
    else
      flash[:alert] = "You can't edit another's answer"
    end
  end

  def mark_as_best
    if current_user.author_of?(@answer.question)
      @answer.mark_as_best
      flash[:notice] = 'Best answer was chosen successfully!'
    else
      flash[:alert] = "You can't select the answer as best as a non-author!"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "question_channel_#{@answer.question.id}",
                                 html:
                                  ApplicationController.render(partial: 'answers/answer_ws',
                                                               locals: { answer: @answer }),
                                 author_id: current_user.id
  end
end
