class Api::V1::LessonsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_lesson, except: [:index]
  before_action :set_course

  
  def index
    lessons = @course.lessons
    render json: lessons
  end

  def lesson_details
    subjects = @lesson.subjects
    contents = @lesson.contents
    render json: { subjects: subjects, contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson not found' }, status: :not_found
  end

  def mark_lesson_as_done
    if @lesson.update(done: true)
      render json: { message: 'Lesson marked as done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark lesson as done' }, status: :unprocessable_entity
    end
  end

  def unmark_lesson_as_done
    if @lesson.update(done: false)
      render json: { message: 'Lesson marked as not done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark lesson as not done' }, status: :unprocessable_entity
    end
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
