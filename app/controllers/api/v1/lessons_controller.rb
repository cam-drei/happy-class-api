class Api::V1::LessonsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_course
  
  def index
    lessons = course.lessons
    render json: lessons
  end

  def subjects_for_course
    course = current_user.courses.find(params[:course_id])
    lesson = course.lessons.find(params[:lesson_id])
    subjects = lesson.subjects
    render json: { subjects: subjects }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson not found' }, status: :not_found
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end
end
