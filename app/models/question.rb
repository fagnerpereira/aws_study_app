class Question < ApplicationRecord
  belongs_to :lesson

  # Associations
  has_many :user_answers, dependent: :destroy

  # Validations
  validates :question_type, presence: true, inclusion: { in: %w[multiple_choice true_false scenario drag_drop] }
  validates :content, presence: true
  validates :correct_answer, presence: true
  validates :experience_points, presence: true, numericality: { greater_than: 0 }

  # Serialize options as JSON
  serialize :options, type: Array, coder: JSON

  # Scopes
  scope :by_type, ->(type) { where(question_type: type) }
  scope :in_lesson, ->(lesson) { where(lesson: lesson) }

  def answered_correctly_by_user?(user)
    user_answers.where(user: user, correct: true).exists?
  end

  def user_answer_for(user)
    user_answers.find_by(user: user)
  end

  def formatted_options
    return [] unless options.present?

    case question_type
    when "multiple_choice"
      options
    when "true_false"
      [ "True", "False" ]
    else
      options
    end
  end
end
