class Domain < ApplicationRecord
  # Associations
  has_many :lessons, dependent: :destroy
  has_many :questions, through: :lessons

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :position, presence: true, uniqueness: true
  validates :weight, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 1 }

  # Scopes
  scope :ordered, -> { order(:position) }

  def completion_percentage_for_user(user)
    return 0 if lessons.count == 0

    completed_lessons = user.completed_lessons.where(domain: self).count
    (completed_lessons.to_f / lessons.count * 100).round(2)
  end

  def total_experience_points
    questions.sum(:experience_points)
  end
end
