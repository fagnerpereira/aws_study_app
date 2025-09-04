class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  
  # Validations
  validates :selected_answer, presence: true
  validates :user_id, uniqueness: { scope: :question_id }
  
  # Callbacks
  before_save :check_correctness
  
  # Scopes
  scope :correct, -> { where(correct: true) }
  scope :incorrect, -> { where(correct: false) }
  scope :for_lesson, ->(lesson) { joins(:question).where(questions: { lesson: lesson }) }
  
  private
  
  def check_correctness
    self.correct = (selected_answer == question.correct_answer)
    self.answered_at = Time.current
  end
end
