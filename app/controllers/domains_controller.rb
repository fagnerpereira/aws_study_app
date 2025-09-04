class DomainsController < ApplicationController
  def index
    @domains = Domain.ordered.includes(:lessons)

    if logged_in?
      @user_progress = @domains.map do |domain|
        {
          domain: domain,
          completion_percentage: domain.completion_percentage_for_user(current_user),
          total_lessons: domain.lessons.count,
          completed_lessons: current_user.completed_lessons.where(domain: domain).count
        }
      end
    end
  end

  def show
    @domain = Domain.find(params[:id])
    @lessons = @domain.lessons.ordered

    if logged_in?
      @completed_lesson_ids = current_user.completed_lessons.where(domain: @domain).pluck(:id)
      @domain_progress = {
        completion_percentage: @domain.completion_percentage_for_user(current_user),
        total_lessons: @lessons.count,
        completed_lessons: @completed_lesson_ids.count
      }
    end
  end
end
