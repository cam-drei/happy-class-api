class Api::V1::LessonsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_lesson, except: [:index]
  before_action :set_course, only: [:index]

  
  def index
    lessons = @course.lessons
    render json: lessons
  end

  def contents_for_lesson
    contents = @lesson.contents
    render json: { contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson not found' }, status: :not_found
  end

  private

  def find_lesson
    course = current_user.courses.find(params[:course_id])
    @lesson = course.lessons.find(params[:lesson_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson not found' }, status: :not_found
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end
