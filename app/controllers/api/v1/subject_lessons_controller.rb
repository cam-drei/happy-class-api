class Api::V1::SubjectLessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_lesson, only: [:subject_lessons_with_contents]
  before_action :find_course_and_lesson, only: [:combined_data]

  def subject_lessons_with_contents
    subject_lessons = @lesson.subject_lessons.includes(:contents)
    render json: { subject_lessons: subject_lessons.map { |sl| sl.as_json.merge(contents: sl.contents) } }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson or subject lesson not found' }, status: :not_found
  end

  def combined_data
    subject_lessons = @lesson.subject_lessons.includes(:contents)
    user_subject_lessons = current_user.user_subject_lessons.where(subject_lesson_id: subject_lessons.map(&:id))

    response = {
      lesson: @lesson,
      subject_lessons: subject_lessons.as_json(include: :contents),
      user_subject_lessons: user_subject_lessons,
      lesson_contents: @lesson.contents
    }

    render json: response, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson not found' }, status: :not_found
  end

  private

  def find_subject_lesson
    course = current_user.courses.find(params[:course_id])
    lesson = course.lessons.find(params[:lesson_id])
    @subject_lesson = lesson.subject_lessons.find(params[:subject_lesson_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson not found' }, status: :not_found
  end

  def find_lesson
    course = current_user.courses.find(params[:course_id])
    @lesson = course.lessons.find(params[:lesson_id])
  end

  def find_course_and_lesson
    course = current_user.courses.find(params[:course_id])
    @lesson = course.lessons.find(params[:lesson_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course or Lesson not found' }, status: :not_found
  end
end
