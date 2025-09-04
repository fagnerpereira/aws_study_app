class Lesson < ApplicationRecord
  belongs_to :domain
  
  # Associations
  has_many :questions, dependent: :destroy
  has_many :user_progresses, dependent: :destroy
  has_many :users_completed, through: :user_progresses, source: :user
  
  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :position, presence: true
  
  # Scopes
  scope :ordered, -> { order(:position) }
  scope :in_domain, ->(domain) { where(domain: domain) }
  
  def completed_by_user?(user)
    user_progresses.exists?(user: user)
  end
  
  def completion_percentage_for_user(user)
    return 0 if questions.count == 0
    
    correct_answers = user.user_answers
                         .joins(:question)
                         .where(questions: { lesson: self }, correct: true)
                         .count
    
    (correct_answers.to_f / questions.count * 100).round(2)
  end
  
  def total_experience_points
    questions.sum(:experience_points)
  end
end
