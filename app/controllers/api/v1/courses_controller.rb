class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_user!

  def course_details
    course = current_user.courses.find(params[:course_id])
    lessons = course.lessons
    contents = course.contents
    render json: { lessons: lessons, contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end
end
