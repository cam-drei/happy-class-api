class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def enrolled_courses
    @user = current_user
    @enrolled_courses = @user ? @user.courses : []
    render json: { enrolled_courses: @enrolled_courses }, status: :ok
  end

  def course_lessons
    @user = current_user
    @course_lessons = @user ? @user.lessons : []
    render json: { course_lessons: @course_lessons }, status: :ok
  end
end
