class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :user_progresses, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  has_many :completed_lessons, through: :user_progresses, source: :lesson

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :experience_points, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :level, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :current_streak, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_validation :set_defaults, on: :create

  # Scopes
  scope :by_level, ->(level) { where(level: level) }
  scope :active_today, -> { where(last_activity_date: Date.current) }

  def update_streak!
    if last_activity_date == Date.current - 1.day
      increment!(:current_streak)
    elsif last_activity_date != Date.current
      update!(current_streak: 1)
    end
    update!(last_activity_date: Date.current)
  end

  def add_experience!(points)
    new_xp = experience_points + points
    new_level = calculate_level(new_xp)

    update!(
      experience_points: new_xp,
      level: new_level,
      last_activity_date: Date.current
    )

    update_streak!
  end

  private

  def set_defaults
    self.experience_points ||= 0
    self.level ||= 1
    self.current_streak ||= 0
    self.last_activity_date ||= Date.current
  end

  def calculate_level(xp)
    # Simple leveling formula: level = sqrt(xp / 100) + 1
    # Level 1: 0-99 XP, Level 2: 100-399 XP, Level 3: 400-899 XP, etc.
    (Math.sqrt(xp / 100.0) + 1).floor
  end
end
