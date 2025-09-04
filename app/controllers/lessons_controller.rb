class LessonsController < ApplicationController
  before_action :require_user
  before_action :set_lesson
  
  def show
    @domain = @lesson.domain
    @questions = @lesson.questions.includes(:user_answers)
    @user_progress = current_user.user_progresses.find_by(lesson: @lesson)
    
    # Get user's answers for this lesson
    @user_answers = current_user.user_answers
                                .where(question: @questions)
                                .index_by(&:question_id)
    
    # Calculate lesson completion
    @total_questions = @questions.count
    @answered_questions = @user_answers.count
    @correct_answers = @user_answers.values.count(&:correct)
    @completion_percentage = @total_questions > 0 ? (@correct_answers.to_f / @total_questions * 100).round(2) : 0
  end
  
  def complete
    @user_progress = current_user.user_progresses.find_or_initialize_by(lesson: @lesson)
    
    unless @user_progress.completed?
      # Calculate final score
      questions = @lesson.questions
      correct_answers = current_user.user_answers
                                   .where(question: questions, correct: true)
                                   .count
      
      score = questions.count > 0 ? (correct_answers.to_f / questions.count * 100).round(2) : 0
      
      # Mark lesson as completed
      @user_progress.mark_completed!(score)
      
      # Award experience points
      xp_earned = @lesson.total_experience_points
      current_user.add_experience!(xp_earned)
      
      flash[:notice] = "Lesson completed! You earned #{xp_earned} XP. Score: #{score}%"
    else
      flash[:alert] = "You have already completed this lesson"
    end
    
    redirect_to domain_lesson_path(@lesson.domain, @lesson)
  end
  
  def answer_question
    question = @lesson.questions.find(params[:question_id])
    
    # Create or update user answer
    user_answer = current_user.user_answers.find_or_initialize_by(question: question)
    user_answer.selected_answer = params[:selected_answer]
    
    if user_answer.save
      xp_earned = user_answer.correct? ? question.experience_points : 0
      
      if xp_earned > 0
        current_user.add_experience!(xp_earned)
        flash[:notice] = "Correct! You earned #{xp_earned} XP."
      else
        flash[:alert] = "Incorrect. Try again!"
      end
    end
    
    redirect_to domain_lesson_path(@lesson.domain, @lesson)
  end
  
  private
  
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end
end
