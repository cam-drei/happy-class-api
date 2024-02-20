class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_user!

  def lessons_for_course
    course = current_user.courses.find(params[:course_id])
    lessons = course.lessons
    render json: { lessons: lessons }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end
end
