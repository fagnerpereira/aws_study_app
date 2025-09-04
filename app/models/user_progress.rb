class UserProgress < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  
  # Validations
  validates :user_id, uniqueness: { scope: :lesson_id }
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :attempts, numericality: { greater_than: 0 }
  
  # Scopes
  scope :completed, -> { where.not(completed_at: nil) }
  scope :for_domain, ->(domain) { joins(:lesson).where(lessons: { domain: domain }) }
  scope :recent, -> { order(completed_at: :desc) }
  
  def completed?
    completed_at.present?
  end
  
  def mark_completed!(score)
    update!(
      completed_at: Time.current,
      score: score
    )
  end
end
