class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_course


  def lessons_for_course
    lessons = @course.lessons
    render json: { lessons: lessons }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def contents_for_course
    contents = @course.contents
    render json: { contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def subjects_for_course
    subjects = @course.subjects
    render json: { subjects: subjects }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def selected_subjects_for_course
    selected_subjects = @course.subjects.where(selected: true)
    render json: { selected_subjects: selected_subjects }, status: :ok
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
