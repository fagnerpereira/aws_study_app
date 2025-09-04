class UsersController < ApplicationController
  before_action :require_guest, only: [ :new, :create ]
  before_action :require_user, only: [ :show ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to AWS Study App, #{@user.name}!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @user = current_user
    @completed_lessons = @user.completed_lessons.includes(:domain)
    @total_xp = @user.experience_points
    @current_level = @user.level
    @current_streak = @user.current_streak

    # Calculate progress per domain
    @domain_progress = Domain.ordered.map do |domain|
      {
        domain: domain,
        completion_percentage: domain.completion_percentage_for_user(@user),
        total_lessons: domain.lessons.count,
        completed_lessons: @user.completed_lessons.where(domain: domain).count
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
