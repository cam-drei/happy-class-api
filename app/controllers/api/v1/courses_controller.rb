class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_course, except: [:index]

  def index
    courses = Course.all
    render json: { courses: courses }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

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

  def course_status
    status = if @course.lessons.present?
      lesson_ids = @course.lessons.pluck(:id)
      total_lessons_count = lesson_ids.count
      done_lessons_count = UserLesson.where(lesson_id: lesson_ids, user_id: current_user.id, done: true).count
      
      if done_lessons_count == total_lessons_count
        'Done'
      elsif done_lessons_count > 0
        'In Progress'
      else
        'Todo'
      end
    else
      'No Lessons'
    end
    render json: { status: status }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  private

  def find_course
    @course = current_user.courses.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end
end
