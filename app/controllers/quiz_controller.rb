class QuizController < ApplicationController
  before_action :initialize_session

  def index
    @categories = QuizService.categories
  end

  def categories
    render json: { categories: QuizService.categories }
  end

  def questions
    category_id = params[:category_id]
    questions = QuizService.questions_for_category(category_id)
    
    # Guardar las preguntas en la sesión para validación posterior
    session[:current_quiz] = {
      category_id: category_id,
      questions: questions.map(&:to_h),
      current_question: 0,
      score: 0,
      answers: {}
    }
    
    render json: { questions: questions.map(&:to_h) }
  end

  def submit_answer
    question_id = params[:question_id]
    user_answer = params[:answer]
    
    quiz_data = session[:current_quiz]
    return render json: { error: 'No active quiz' }, status: 400 unless quiz_data

    question = quiz_data['questions'].find { |q| q['id'] == question_id }
    return render json: { error: 'Question not found' }, status: 404 unless question

    # Verificar respuesta
    is_correct = QuizService.check_answer(question, user_answer)
    
    # Actualizar sesión
    quiz_data['answers'][question_id] = user_answer
    quiz_data['score'] += 1 if is_correct
    session[:current_quiz] = quiz_data

    render json: {
      correct: is_correct,
      explanation: question['explanation'],
      correct_answer: question['correct_answer']
    }
  end

  def results
    quiz_data = session[:current_quiz]
    return render json: { error: 'No quiz data' }, status: 400 unless quiz_data

    total_questions = quiz_data['questions'].length
    score = quiz_data['score']
    percentage = (score.to_f / total_questions * 100).round

    render json: {
      score: score,
      total: total_questions,
      percentage: percentage,
      evaluation: QuizService.get_evaluation(percentage)
    }
  end

  private

  def initialize_session
    session[:current_quiz] ||= {}
  end
end