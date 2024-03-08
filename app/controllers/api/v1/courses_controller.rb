class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_course


  def course_details
    lessons = @course.lessons
    contents = @course.contents
    render json: { lessons: lessons, contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def mark_course_as_done
    if @course.update(done: true)
      render json: { message: 'Course marked as done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark course as done' }, status: :unprocessable_entity
    end
  end

  def unmark_course_as_done
    if @course.update(done: false)
      render json: { message: 'Course marked as not done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark course as not done' }, status: :unprocessable_entity
    end
  end

  private

  def find_course
    @course = current_user.courses.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end
end
