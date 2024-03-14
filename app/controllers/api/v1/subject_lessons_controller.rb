class Api::V1::SubjectLessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_subject_lesson, only: [:mark_subject_lesson_as_done, :unmark_subject_lesson_as_done]
  before_action :find_lesson, only: [:subject_lessons_for_lesson, :subject_lesson_contents_for_lesson]

  def subject_lessons_for_lesson
    subject_lessons = @lesson.subject_lessons.as_json(include: :subject)
    render json: { subject_lessons: subject_lessons.as_json(include: :subject) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lessonsss not found' }, status: :not_found
  end

  def subject_lesson_contents_for_lesson
    subject_lessons = @lesson.subject_lessons
    subject_lesson_contents = subject_lessons.map { |subject_lesson| subject_lesson.contents }.flatten
    render json: { subject_lesson_contents: subject_lesson_contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson not found' }, status: :not_found
  end

  def mark_subject_lesson_as_done
    if @subject_lesson.update(done: true)
      render json: { message: 'Subject marked for lesson as done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark subject for lesson as done' }, status: :unprocessable_entity
    end
  end

  def unmark_subject_lesson_as_done
    if @subject_lesson.update(done: false)
      render json: { message: 'Subject for lesson marked as not done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark subject for lesson as not done' }, status: :unprocessable_entity
    end
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

end
