class QuestionsController < ApplicationController
  include Voted

  skip_before_action :authenticate_user!, only: [:index, :show]

  before_action :set_question, only: [:show, :destroy, :update]

  after_action :publish_question, only: [:create]

  def index
    @questions = policy_scope(Question)
  end

  def show
    gon.question_user_id = @question.user_id
  end

  def create
    authorize Question
    @question = current_user.questions.create(question_params)
    render_json @question
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: t('.message')
  end

  def update
    @question.update(question_params)
    render_json @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
    authorize @question
    gon.question_id = @question.id
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      "questions",
      {
        question: ApplicationController.render(
          locals: { question: @question },
          partial: 'questions/question'
        )
      }
    )
  end
end
